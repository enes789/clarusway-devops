#------ root/main.tf ---


module "vpc" {
  source                     = "./vpc"
  vpc_cidr                   = local.vpc_cidr
  access_ip                  = var.access_ip
  alb_security_group         = var.alb_security_group
  ec2_security_group         = var.ec2_security_group
  rds_security_group         = var.rds_security_group
  natinstance_security_group = var.natinstance_security_group
  public_sn_count            = 2
  private_sn_count           = 2
  max_subnets                = 20
  public_cidrs               = [for i in range(10, 255, 10) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs              = [for i in range(11, 255, 10) : cidrsubnet(local.vpc_cidr, 8, i)]
  service_name               = "com.amazonaws.us-east-1.s3"
  service_type               = "Gateway"
  db_subnet_group            = true
  network_interface_id       = module.ec2.network_interface_id

}

module "rds" {
  source                  = "./rds"
  db_storage              = 20
  db_engine_version       = "8.0.20"
  db_instance_class       = "db.t2.micro"
  dbname                  = var.dbname
  dbuser                  = var.dbuser
  dbpassword              = var.dbpassword
  db_identifier           = "aws-capstone-rds"
  skip_db_snapshot        = true
  db_subnet_group_name    = module.vpc.db_subnet_group_name[0]
  vpc_security_group_ids  = module.vpc.db_security_group
  backup_retention_period = 7
  backup_window           = "01:00-02:00"
  maintenance_window      = "Sun:03:00-Sun:04:00"
  deletion_protection     = false
}

module "s3" {
  source               = "./s3"
  static_website_files = "./documents/S3_Static_Website"

}

module "ec2" {
  source         = "./ec2"
  natinstance_sg = module.vpc.natinstance_sg
  public_subnets = module.vpc.public_subnets[0]
  #instance_count  = 2
  instance_type = "t2.micro"
  key_name      = "mykey1"
}

module "iam" {
  source = "./iam"
}

module "launch_template" {
  source               = "./launch_template"
  instance_type        = "t2.micro"
  key_name             = "mykey1"
  launch_template_sg   = module.vpc.launch_template_sg
  iam_instance_profile = module.iam.aws_capstone_ec2_s3_full_access
  #private_subnets = module.vpc.private_subnets
  user_data_path = "${path.root}/userdata.sh"
  dbname         = var.dbname
  dbuser         = var.dbuser
  dbpassword     = var.dbpassword
  db_address     = module.rds.db_address
  bucket_name    = module.s3.blog_bucket_name
  depends_on     = [module.rds.db_address, module.s3.blog_bucket_name]

}

module "elb-asg" {
  source                         = "./elb-asg"
  alb_sg                         = module.vpc.alb_sg
  public_subnets                 = module.vpc.public_subnets
  private_subnets                = module.vpc.private_subnets
  tg_port                        = 80
  tg_protocol                    = "HTTP"
  vpc_id                         = module.vpc.vpc_id
  lb_healthy_threshold           = 2
  lb_unhealthy_threshold         = 2
  lb_timeout                     = 5
  lb_interval                    = 30
  launch_template_id             = module.launch_template.launch_template_id
  launch_template_latest_version = module.launch_template.launch_template_latest_version
  #listener_port          = 80
  #listener_protocol      = "HTTP"

}

module "cloudfront" {
  source                   = "./cloudfront"
  domain_name              = module.elb-asg.lb_endpoint
  origin_id                = "ALBOriginId"
  enabled                  = true
  aliases                  = ["www.aenesdemir.tk"]
  origin_protocol_policy   = "match-viewer"
  http_port                = "80"
  https_port               = "443"
  origin_keepalive_timeout = 5
  origin_ssl_protocols     = ["TLSv1"]
  viewer_protocol_policy   = "redirect-to-https"
  allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods           = ["GET", "HEAD", "OPTIONS"]
  headers                  = ["Host", "Accept", "Accept-Charset", "Accept-Datetime", "Accept-Encoding", "Accept-Language", "Authorization", "Cloudfront-Forwarded-Proto", "Origin", "Referrer"]
  acm_certificate_arn      = "arn:aws:acm:us-east-1:759037523915:certificate/fe7b734b-8322-46f5-ba80-ff21f7c1f3ea"
  ssl_support_method       = "sni-only"
  restriction_type         = "none"
  compress                 = true
  cookies_forward          = "all"
  query_string             = true

}

module "route53" {
  source     = "./route53"
  fqdn       = module.cloudfront.cloudfront_domain_name
  zone_id    = module.cloudfront.cloudfront_hosted_zone_id
  alias_s3   = module.s3.s3_website_endpoint
  zone_id_s3 = module.s3.s3_hosted_zone_id

}

module "dynamodb" {
  source = "./dynamodb"
}

module "lambda" {
  source = "./lambda"
  iam_role_for_lambda = module.iam.iam_role_for_lambda

}
