import 'package:equatable/equatable.dart';
import 'package:bagle/bagle/widgets/bagle.dart';

/*
The "Word" class splits the letters and adds them into a list.
In case we need the word in string form we join them together in "wordString".
The Equatable package allows us to comapre the word and it's status to check
for it's equality.
*/

class Word extends Equatable {
  const Word({required this.letters});

  // Splits the word into individual characters and puts them into a list.
  factory Word.fromString(String word) =>
      Word(letters: word.split('').map((e) => Letter(val: e)).toList());

  // A list of the "Letter" class.
  final List<Letter> letters;

  // Joins the letters into a word incase we need the string version.
  String get wordString => letters.map((e) => e.val).join();

  void addLetter(String val) {
    // Points our cursor to the first index of the empty string.
    final currentIndex = letters.indexWhere((e) => e.val.isEmpty);
    // Sets the letter at the proper position.
    if (currentIndex != -1) {
      letters[currentIndex] = Letter(val: val);
    }
  }

  void removeLetter() {
    // Points our cursor to the last index of the string.
    final recentLetterIndex = letters.lastIndexWhere((e) => e.val.isNotEmpty);
    if (recentLetterIndex != -1) {
      // Deletes the letter by setting it to empty.
      letters[recentLetterIndex] = Letter.empty();
    }
  }

  // Compares the value and it's status. (Required by Equatable)
  @override
  List<Object?> get props => [letters];
}
