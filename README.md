# Vigenère cipher

I built this app to both encode a message with the [Vigenère cipher](http://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher) and crack a code given only the approximate length of the key. It is fully tested and will work with any given wordlist.

## TODO

Speed things up. With a small wordlist, cracking a code works extremely fast. But when the wordlist grows to over 20,000 words, it can take quite a while.

## Instructions

To encode a message:

```ruby
require_relative 'vigenere\_cipher'
var = VigenereCipher.new(key, message).
var.code
```

To crack a code:

```ruby
VigenereCipher.crack(code) 
```

I've also included a really small dictionary file for testing purposes.
