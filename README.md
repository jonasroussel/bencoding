# Bencoding
[![pub package](https://img.shields.io/pub/v/bencoding.svg)](https://pub.dev/packages/bencoding)

A dart library for encoding and decoding bencoded data,
according to the [BitTorrent specification](https://wiki.theory.org/index.php/BitTorrentSpecification#Bencoding).

## Index

- [About BEncoding](#about-bencoding)
- [Usage](#usage)
- [API](#api)

## About BEncoding

from [Wikipedia](https://en.wikipedia.org/wiki/Bencode):

Bencode (pronounced like B encode) is the encoding used by the peer-to-peer
file sharing system BitTorrent for storing and transmitting loosely structured data.

It supports four different types of values:
- byte strings
- integers
- lists
- dictionaries

Bencoding is most commonly used in torrent files.
These metadata files are simply bencoded dictionaries.

## Usage

### Import
```dart
import 'package:bencoding/bencode.dart' as bencode;
```

### Encoding

```dart
final data = {
  'string': 'Hello World',
  'integer': 12345,
  'dict': {
    'key': 'This is a string within a dictionary',
  },
  'list': [ 1, 2, 3, 4, 'string', 5, {} ],
};

final buffer = bencode.encode(data); // Return a Uint8List
final string = bencode.encodeToString(data); // Return a String

print('Buffer: $buffer');
print('String: $string');
```

#### Output

```
Buffer: [100, 54, 58, 115, 116, 114, 105, 110, 103, 49, 49, ...]
String: d6:string11:Hello World7:integeri12345e4:dictd3:key36:This is ...
```

### Decoding

```dart
final bencodedData = 'd6:string11:Hello World7:integeri12345e4:dictd3:key36:This is a string within a dictionarye4:listli1ei2ei3ei4e6:stringi5edeee';

print(bencode.decodeString(bencodedData));
// or you can use bencode.deocode(data) if your input data is a buffer (Uint8List)
```

#### Output

```dart
{
  'string': 'Hello World',
  'integer': 12345,
  'dict': {
    'key': 'This is a string within a dictionary',
  },
  'list': [ 1, 2, 3, 4, 'string', 5, {}],
}
```

## API

### encode( `dynamic` *data* )
> `String` | `int` | `List` | `Map` *data*

Returns `Uint8List`

### encodeToString ( `dynamic` *data* )
> `String` | `int` | `List` | `Map` *data*

Returns `String`

### decode( `Uint8List` *data* )
Returns `dynamic` (`String` | `int` | `List` | `Map`)

### decodeString ( `String` *data* )
Returns `dynamic` (`String` | `int` | `List` | `Map`)
