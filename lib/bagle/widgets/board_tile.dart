import 'package:flutter/material.dart';
import 'package:bagle/bagle/models/letter_model.dart';

/*
This class is the specific tile on the board. It is then mapped to a word and
put into a column by the "Board" class.
*/

class BoardTile extends StatelessWidget {
  const BoardTile({
    Key? key,
    required this.letter,
  }) : super(key: key);

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    // Displays the cell that contains the letter.
    return Container(
      margin: const EdgeInsets.all(4),
      height: 48,
      width: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: letter.backgroundColor,
        border: Border.all(color: letter.borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      // Displays the letter through a "Text" widget.
      child: Text(
        letter.val,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
