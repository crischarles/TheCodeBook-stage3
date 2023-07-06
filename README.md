# Monoalphabetic Cipher with Homophones

##Deciphering the text of the third stage of the book "The Code Book" with SHELL

This stage was more complicated to decipher than the first two, not only because of the text itself (which contained homophones and a non-letter character), but to create a strategy where the Shell could do something more standardized and comprehensive.
Since the first stage is more like this one, I was able to leverage some knowledge.
The first challenge was to discover the language of the ciphertext. As the first stage was in PT-BR and the second in Latin, I assumed it could be PT-BR again or a new language (maybe one for each stage). That's why I had to create different versions to decipher at least 5 different languages until I found the one that made the most sense, since, using frequency analysis, I need to focus on a single language. 

During the frequency analysis, I noticed that in addition to the odd character (which was not a letter), there was an extremely high frequency of the X, so I assumed it could be a space, since the ciphertext didn't have any, the odd character was infrequent enough to be space, then it could be replacing the X's position in the alphabet array. After some tests with different languages, the ITALIAN language made the most sense (I don't know Italian, but a look at some Italian websites helps you understand some language patterns).

Once working in the Italian language, I developed versions 1.0, 1.1, 1.2 and 1.3 to increase the accuracy of the cipher text, which after the last version, I was able to reach more than 94% accuracy, which makes the text understandable enough to see its content and discover the password.
Once again, I don't work on letters with low frequency so as not to mess up the rest of the text. But looking at the text you can see where the other ~6% are (letters Z, Q, D, M).

As a result, it can be seen that the ciphertext is a quote from the book "La Divina Commedia - Inferno, Canto XXVI" by Dante Alighieri, and that the password is equator (read Q instead of Z).

Version 1.0
In this version, the frequency analysis of the letters in a crude form is applied, changing all those that are more frequent in the ciphertext by the most frequent ones in an Italian text.
The most frequent character will be understood as a space, which ended up happening in this case with the letter X.
There is also an additional function for handling the letter A separately, this was implemented after analyzing the versions ahead, and it would make more sense to implement it in version 1.0, removing it from the frequency array. This was a very particular case that only happened with the letter A, where it was ciphered by several different letters throughout the text.

Version 1.1
Two 3-letter words are chosen to increase the accuracy of the deciphered text in this version, the most frequent is CHE, the second, also frequent is NON, the advantage of the latter is that it has the same first and third letter, facilitating the search, identification and replacement.

Version 1.2
In this version, another frequent word in the Italian text is used, but this time with five letters, TUTTE, I also take advantage of the fact that it contains 3 equal letters for search, identification and replacement.

Version 1.3
The letter L is searched for in this version using another method, it can often be found in Italian texts without being pressed by another letter, as in the word "l'esperienza", in addition to it, the letters A, E and I are also found lonely, so I remove them from the search list.


## Additional Information 

Links that helped me with decipher this: 
One of the random texts used for frequency analysis: https://www.aranzulla.it/libri-pdf-gratis-62036.html#sub-chapter1

Italian dictionary: https://www.treccani.it/vocabolario/

La divina commedia book: https://bibdig.biblioteca.unesp.br/items/dc249e33-db19-45ff-9dfc-6c0f1cb20001/full

letters frequency:
https://en.wikipedia.org/wiki/Letter_frequency
https://www.sttmedia.com/characterfrequency-italian
https://www.sttmedia.com/syllablefrequency-italian
https://www.reddit.com/r/dataisbeautiful/comments/ls83py/frequency_of_letters_in_italian_words_and_where/

## How to run the script

You just have to give a ciphertext file to the script as a parameter, as below:

./script.sh file.txt

The ciphertext must be in upper case, if your ciphertext is in lower case, you can convert it here:
https://convertcase.net/
