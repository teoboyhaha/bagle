/*
Bagle - Created 2022
Instructions:
Run the game by tapping on the app icon. You have 6 tries to guess a 5 letter
food-related food. Tap on the keys on the keyboard at the bottom of the screen
to type a key. Submit your guess after filling in all of the tiles in your
row by pressing the "ENTER" button on the bottom left. If you made a mistake,
you may press the "DEL" button to delete a letter.

The aim of the game is to guess a food-related word. Colors can give clues on
how close your guess was. Green means you guessed the right letter in the right
tile, yellow means you guessed the right letter but it's not in the right tile,
and grey means the letter is not present in the word.

You win after guessing the word! If you use all 6 guesses without finding the
solution, you lose.
*/

import 'package:flutter/material.dart';
import 'package:bagle/app/app.dart';

// Runs the code from the class, "App"
void main() => runApp(const App());
