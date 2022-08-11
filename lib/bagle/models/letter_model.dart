import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:bagle/app/app_colors.dart';

// Identifies the type of letter it is when the player submits.
enum LetterStatus { initial, notInWord, inWord, correct }

/*
Each tile holds a letter on the game board.
When we bring these letters together it makes up a word.
The Equatable package allows us to comapre the letter and it's status to check
for it's equality.
*/

class Letter extends Equatable {
  const Letter({
    // Constructor
    required this.val,
    this.status = LetterStatus.initial,
  });

  // Uses an empty letter so the board can be populated with empty strings.
  factory Letter.empty() => const Letter(val: '');

  // Sorts the letter string.
  final String val;

  final LetterStatus status;

  // Shows the proper color for the letter based on it's status.
  Color get backgroundColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.transparent;
      case LetterStatus.notInWord:
        return notInWordColor;
      case LetterStatus.inWord:
        return inWordColor;
      case LetterStatus.correct:
        return correctColor;
    }
  }

  // Shows the proper color for the letter.
  Color get borderColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  // Returns a copy of the letter and it's emutable status.
  Letter copyWith({String? val, LetterStatus? status}) {
    return Letter(
      val: val ?? this.val,
      status: status ?? this.status,
    );
  }

  // Compares the value and it's status. (Required by Equatable)
  @override
  List<Object> get props => [val, status];
}
