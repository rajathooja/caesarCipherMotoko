import Text "mo:base/Text";
import Char "mo:base/Char";

actor caesarCipher {
  // set the Caesar Cipher encryption key
  let strKey : Text = "abcdefghijklmnopqrstuvwxyz";
  let natKeyLength : Nat = strKey.size();
  
  // initialize variables
  var natOffset : Nat = 0;
  var strInput : Text = "";
  var strEncodedInput : Text = "";

  // public function to encode the plain text input
  // returns a scrambled Text string
  public func encodeInput(plainText : Text) : async Text {
    // initialize variables
    var charEncoded : Char = ' ';
    var natNewCharIndex : Nat = 0;
    var strEncodedInput : Text = "";

    // assign the plain text input to a global variable for access by public query getter
    strInput := plainText;

    // loop through each character of the input string, 
    // offset each character based on the cipher key,
    // concatenate and return the encoded string
    label iterator for (charCurrent in strInput.chars()) {

      // if the current character being iterated over is a white space, 
      // leave the space as is and continue to the next character
      if (Char.isWhitespace(charCurrent)) {
        strEncodedInput #= Char.toText(charCurrent);
        continue iterator;
      };

      // determine the position index of the current character in the cipher key
      var natCurrCharIndex : Nat = getIndex(strKey, charCurrent);

      // add the offset to the current index to determine 
      // the position (index) of the new (encoded) character we should return
      natNewCharIndex := natCurrCharIndex + natOffset;

      // if the new position is greater than the key length,
      // wrap around to the beginning of the key by subtracting
      // the key length from the new position.
      // this allows the end of the alphabet to be properly encoded 
      // by wrapping around from 'z' to 'a'
      // i.e. if we go to encode letter 'Z' with an offset of 3, the position will be 29
      // so, wrap around to the start of the alphabet (29 - 26 = 3) 
      // and you see that 'C' is the correct encoded position for 'Z' offset by 3
      if (natNewCharIndex >= natKeyLength) {
        natNewCharIndex := natNewCharIndex - natKeyLength;
      };

      // using the new position of the new character, we get that new character from the cipher key
      charEncoded := getChar(strKey, natNewCharIndex);

      // concatenate the encoded character to our encoded string
      strEncodedInput #= Char.toText(charEncoded);

    };

    // return the encoded string
    return strEncodedInput;
  };

  // private utility method to return a character at a given position (index) in a Text string
  private func getChar(string : Text, index : Nat) : Char {
    // initialize the counter
    var count : Nat = 0;
    // initialize our character to return
    var myChar : Char = ' ';

    // loop over each character in the supplied string
    label iterator for (c in Text.toIter(string)) {
      // if the current loop count is equal to the supplied index,
      if (count == index) {
        // we have found the character we are looking for, so assign it to our variable.
        myChar := c;
        
        // exit the loop
        break iterator;
      };

      // else, incremenet the loop count
      count += 1;
    };

    // return the character we found at the given index
    return myChar;
  };

  // private utility method to return the index position of a given character in a Text string
  private func getIndex(string : Text, myChar : Char) : Nat {
    // initialize our index to return
    var index : Nat = 0;

    // loop over each character in the supplied string
    label iterator for (c in Text.toIter(string)) {
      // if the current character is equal to the supplied character
      if (c == myChar) {
        // we have found the character we are looking for, so exit the loop
        break iterator;
      };

      // else, increment the loop (index) count
      index += 1;
    };

    // return the index we found for the given character
    return index;
  };

  // public setter for setting the desired encoding offset
  public func setOffset(offset : Nat) : async() {

    natOffset := offset;
  };

  // public getter for showing (returning) the encoding offset
  public query func getOffset() : async Nat {
    
    return natOffset;
  };

  // public getter for showing (returning) the original plain text string
  public query func getOriginal() : async Text {
    
    return strInput;
  };

};