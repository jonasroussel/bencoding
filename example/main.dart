import 'package:bencoding/bencode.dart' as bencode;

void main() {
  final data = {
    'string': 'Hello World',
    'integer': 12345,
    'dict': {
      'key': 'This is a string within a dictionary',
    },
    'list': [1, 2, 3, 4, 'string', 5, {}],
  };

  final buffer = bencode.encode(data); // Return a Uint8List
  final string = bencode.encodeToString(data); // Return a String

  print('Buffer: $buffer');
  print('String: $string');

  final bencodedData = 'd6:string11:Hello World7:integeri12345e4:dictd3:key36:This is a string within a dictionarye4:listli1ei2ei3ei4e6:stringi5edeee';

  print(bencode.decodeString(bencodedData));
}
