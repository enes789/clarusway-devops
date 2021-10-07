# Coding Challenge - 010: Hangman

The purpose of this coding challenge is to write a program that plays the game called hangman with the user.

## Learning Outcomes

At the end of this coding challenge, students will be able to;

- Analyze a problem, identify, and apply programming knowledge for an appropriate solution.

- Implement conditional statements effectively to solve a problem.

- Implement loops to solve a problem.

- Execute operations on strings.

- Decompose the problem into sub-problems and solve them distinctly using functions.

- Implement lists to solve a problem.

- Demonstrate their knowledge of algorithmic design principles by solving the problem effectively.

## Problem Statement

In this coding challenge, you are going to create a hangman game. It is the traditional hangman game. At the beginning of the game, a hidden city name is selected randomly by the computer from the list that is provided to you. Each time computer asks you for a letter you take a guess and try to find the letters in the hidden word. If the letter is in the word, it gets revealed. Otherwise, one part of the hangman is drawn. Hangman has 6 body parts (head, left arm, right arm, body, left leg, right leg). If all the body parts are drawn, you lose. If you reveal the whole hidden world until the hangman is drawn you win. Note that the predictions are case sensitive, which means you have to use a capital letter for the initial of each word.

- Expected Output 1:

```text
________
Predict a letter: O     
 O

Predict a letter: H
 O
/
Predict a letter: l
_l______
Predict a letter: u
 O
/|
Predict a letter: o
_lo_____
Predict a letter: p
 O
/|\

Predict a letter: v
 O
/|\
/
Predict a letter: e
_lo_e__e
Predict a letter: z
 O
/|\
/ \
You lost. The word was: Florence
```
- Expected Output 2:
```
________
Predict a letter: u
 O

Predict a letter: e
_e______
Predict a letter: a
 O
/
Predict a letter: i
_e__i__i
Predict a letter: H
He__i__i
Predict a letter: l
Hel_i__i
Predict a letter: s
Helsi__i
Predict a letter: n
Helsin_i
Predict a letter: k
Helsinki
You won!
```
