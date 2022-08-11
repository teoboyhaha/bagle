import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:bagle/bagle/widgets/bagle.dart';

/*
The "Board" class maps each word into a row of cells. Because there are six
guesses there are six rows in each column.
*/

class Board extends StatelessWidget {
  const Board({
    Key? key,
    required this.board,
    required this.flipCardKeys,
  }) : super(key: key);

  // Takes in a list of words
  final List<Word> board;

  // Takes in a List of a List of GlobalKey and FlipCardState.
  final List<List<GlobalKey<FlipCardState>>> flipCardKeys;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board
          .asMap()
          // Maps each row into a "BoardTile" class.
          .map(
            (i, word) => MapEntry(
              i,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: word.letters
                    .asMap()
                    .map(
                      (j, letter) => MapEntry(
                        j,
                        // Flips the tile when the state changes.
                        FlipCard(
                            key: flipCardKeys[i][j],
                            flipOnTouch: false,
                            direction: FlipDirection.VERTICAL,
                            // The front of the tile is the letter and the value.
                            front: BoardTile(
                                letter: Letter(
                              val: letter.val,
                              status: LetterStatus.initial,
                            )),
                            // The back is a blank tile.
                            back: BoardTile(letter: letter)),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
