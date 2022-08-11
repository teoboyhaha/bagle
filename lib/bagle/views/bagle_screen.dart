import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:bagle/app/app_colors.dart';
import 'package:bagle/bagle/data/word_list.dart';
import 'package:bagle/bagle/models/letter_model.dart';
import 'package:bagle/bagle/models/word_model.dart';
import 'package:bagle/bagle/widgets/board.dart';
import 'package:bagle/bagle/widgets/keyboard.dart';

/*
BagleScreen handles the game state of our application. Game states tell us
when the application whether the user is playing, submitting their word, has
lost or won. If the game is in either of these states, it will change the
screen accordingly.
*/

// Game states
enum GameStatus { playing, submitting, lost, won }

class BagleScreen extends StatefulWidget {
  const BagleScreen({Key? key}) : super(key: key);

  @override
  State<BagleScreen> createState() => _BagleScreenState();
}

class _BagleScreenState extends State<BagleScreen> {
  // Automatically sets the game state to "playing".
  GameStatus _gameStatus = GameStatus.playing;

  // Generates a list of 6 guesses for the user to input words.
  final List<Word> _board = List.generate(
      6, (_) => Word(letters: List.generate(5, (_) => Letter.empty())));

  /* 
  Generates a list of lists of the "GlobalKey" and the "FlipCardState" from
  the Flip Card package. This will coresspond to the tiles on the board so we
  can flip them. GlobalKey allows us to access different parts of the widget
  tree in case the card state has been moved.
  */
  final List<List<GlobalKey<FlipCardState>>> _flipCardKeys = List.generate(
    6,
    (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
  );

  // Keeps track of which guess we're on.
  int _currentWordIndex = 0;

  // Gets which guess the user is on.
  Word? get _currentWord =>
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  // Grabs a random word to be our solution from word_list.dart.
  Word _solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
  );

  // Keeps track of the keys the player has pressed.
  final Set<Letter> _keyboardLetters = {};

  // Builds a widget and returns the "Scaffold" class.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Generates the "BAGLE" title on the top of the screen.
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'BAGLE',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      // Generates the board by aligning the tiles into columns.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board, flipCardKeys: _flipCardKeys),
          const SizedBox(height: 80),
          // Adds the keyboard into the widget and allows BagleScreen to handle inputs.
          Keyboard(
            onKeyTapped: _onKeyTapped,
            onDeleteTapped: _onDeleteTapped,
            onEnterTapped: _onEnterTapped,
            letters: _keyboardLetters,
          )
        ],
      ),
    );
  }

  // Checks if the game is playing and adds a letter to the list.
  void _onKeyTapped(String val) {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.addLetter(val));
    }
  }

  // Checks if the game is playing and removes a letter in the list.
  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.removeLetter());
    }
  }

  /* 
  Checks if the game is playing and if there aren't any empty tiles. It then
  sets the game state to "submitting".
  onEnterTapped is asyncronous so that the code can run while the tile is being
  flipped.
  */
  Future<void> _onEnterTapped() async {
    if (_gameStatus == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      _gameStatus = GameStatus.submitting;

      /*
      Compares the user's word to the solution. It iterates through each
      tile and asks itself if it equals to the index of the letter 
      or if it at least contains a letter. Then it changes it's status
      accordingly.
      */
      for (var i = 0; i < _currentWord!.letters.length; i++) {
        final currentBagletter = _currentWord!.letters[i];
        final currentSolutionLetter = _solution.letters[i];
        setState(() {
          // If the letter and solution's letter is the same then change the status to "correct".
          if (currentBagletter == currentSolutionLetter) {
            _currentWord!.letters[i] =
                currentBagletter.copyWith(status: LetterStatus.correct);
            // If the letter is in the solution's word, change the status to "inWord".
          } else if (_solution.letters.contains(currentBagletter)) {
            _currentWord!.letters[i] =
                currentBagletter.copyWith(status: LetterStatus.inWord);
          } else {
            // If there isn't a letter present in the solution's word, then change the status to "notInWord".
            _currentWord!.letters[i] =
                currentBagletter.copyWith(status: LetterStatus.notInWord);
          }
        });

        final letter = _keyboardLetters.firstWhere(
          (e) => e.val == currentBagletter.val,
          orElse: () => Letter.empty(),
        );
        // If the letter is correct, then update the keyboardLetters list.
        if (letter.status != LetterStatus.correct) {
          _keyboardLetters.removeWhere((e) => e.val == currentBagletter.val);
          _keyboardLetters.add(_currentWord!.letters[i]);
        }

        // Flips the card after 150ms.
        await Future.delayed(
          const Duration(milliseconds: 150),
          () => _flipCardKeys[_currentWordIndex][i].currentState?.toggleCard(),
        );
      }

      // Checks if the user has win or lost after submitting.
      _checkIfWinOrLoss();
    }
  }

  // Compares the submitted word to the solution.
  void _checkIfWinOrLoss() {
    /* 
    If the submitted word is equal to the solution, then change the game state
    to "won" and show a snackbar widget telling the player they have won. 
    */
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: correctColor,
          content: const Text(
            'You won!',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            onPressed: _restart,
            textColor: Colors.white,
            label: 'New Game',
          ),
        ),
      );
      /* 
    If the amount of submitted words exceeds the amuont of guesses, then change
    the game state to "lost", show a snackbar widget telling the player they
    have lost, and tell them what the word was. 
    */
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.redAccent[200],
          content: Text(
            'You lost! Solution: ${_solution.wordString}',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            onPressed: _restart,
            textColor: Colors.white,
            label: 'New Game',
          ),
        ),
      );
      // If none of these things happen, continue playing the game.
    } else {
      _gameStatus = GameStatus.playing;
    }
    // Increment the guess index.
    _currentWordIndex += 1;
  }

  // Resets the original game variables back to their initial states.
  void _restart() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _currentWordIndex = 0;
      _board
        // Clears everything and generates a new list of empty guesses.
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
          ),
        );
      // Sets the solution to a new random word.
      _solution = Word.fromString(
        fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
      );
      // Clears the keyboardLetters list.
      _keyboardLetters.clear();
    });
    // Resets the flipCardKeys list into it's original state.
    _flipCardKeys
      ..clear()
      ..addAll(
        List.generate(
          6,
          (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
        ),
      );
  }
}
