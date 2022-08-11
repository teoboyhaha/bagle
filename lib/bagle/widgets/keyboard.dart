import 'package:flutter/material.dart';
import 'package:bagle/app/app_colors.dart';
import 'package:bagle/bagle/widgets/bagle.dart';

// Represents each key on the onscreen keyboard.
const _qwerty = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DEL'],
];

class Keyboard extends StatelessWidget {
  const Keyboard({
    Key? key,
    required this.onKeyTapped,
    required this.onDeleteTapped,
    required this.onEnterTapped,
    required this.letters,
  }) : super(key: key);

  // Inputs for when the user taps the keyboard.

  final void Function(String) onKeyTapped;

  final VoidCallback onDeleteTapped;

  final VoidCallback onEnterTapped;

  final Set<Letter> letters;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // Map each key on the row into individual buttons.
      children: _qwerty
          .map(
            (keyRow) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: keyRow.map((letter) {
                /* 
                If the user taps any of these buttons it will delete, submit
                their guess, or type a letter into the tile based on the
                letter it's been mapped to.
                */
                if (letter == 'DEL') {
                  return _KeyboardButton.delete(onTap: onDeleteTapped);
                } else if (letter == 'ENTER') {
                  return _KeyboardButton.enter(onTap: onEnterTapped);
                }
                // Corresponds the button on they keyboard to the letter.
                final letterKey = letters.firstWhere(
                  (e) => e.val == letter,
                  orElse: () => Letter.empty(),
                );

                return _KeyboardButton(
                  onTap: () => onKeyTapped(letter),
                  letter: letter,
                  // Changes the background color based on the current letter.
                  backgroundColor: letterKey != Letter.empty()
                      ? letterKey.backgroundColor
                      : keyboardColor,
                );
              }).toList(),
            ),
          )
          .toList(),
    );
  }
}

/*
This class is the specific key on the keyboard.
*/

class _KeyboardButton extends StatelessWidget {
  const _KeyboardButton({
    Key? key,
    this.height = 48,
    this.width = 30,
    required this.onTap,
    required this.backgroundColor,
    required this.letter,
  }) : super(key: key);

  // Factory handles if the key should be different from the others.

  factory _KeyboardButton.delete({
    required VoidCallback onTap,
  }) =>
      _KeyboardButton(
        width: 56,
        onTap: onTap,
        backgroundColor: keyboardColor,
        letter: 'DEL',
      );

  factory _KeyboardButton.enter({
    required VoidCallback onTap,
  }) =>
      _KeyboardButton(
        width: 56,
        onTap: onTap,
        backgroundColor: keyboardColor,
        letter: 'ENTER',
      );

  final double height;

  final double width;

  final VoidCallback onTap;

  final Color backgroundColor;

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 2.0,
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
