import 'dart:convert';
import 'dart:typed_data';

/// Decode bencoded data.
dynamic decode(Uint8List data) {
  var index = _Index(0);

  while (data[index.value] == 32 || data[index.value] == 11 || data[index.value] == 9) {
    index.value++;
  }

  return _getNextData(data, index);
}

/// Decode bencoded data from a String.
dynamic decodeString(String data) {
  return decode(utf8.encode(data));
}

Map<String, dynamic> _dictionary(Uint8List data, _Index index) {
  Map<String, dynamic> result = Map();

  index.value++;

  while (data[index.value] != 101) {
    result[_string(data, index)] = _getNextData(data, index);
  }

  index.value++;

  return result;
}

List<dynamic> _list(Uint8List data, _Index index) {
  List<dynamic> result = [];

  index.value++;

  while (data[index.value] != 101) {
    result.add(_getNextData(data, index));
  }

  index.value++;

  return result;
}

int _integer(Uint8List data, _Index index) {
  final end = data.indexOf(101, index.value);
  final result = _parseInt(data, index.value + 1, end);

  index.value = end + 1;

  return result;
}

String _string(Uint8List data, _Index index) {
  final sep = data.indexOf(58, index.value);
  final length = _parseInt(data, index.value, sep);
  final string = utf8.decode(data.sublist(sep + 1, sep + 1 + length), allowMalformed: true);

  index.value = sep + 1 + length;

  return string;
}

int _parseInt(Uint8List data, int start, int end) {
  var sum = 0;
  var sign = 1;

  for (var i = start; i < end; i++) {
    var number = data[i];

    if (number < 58 && number >= 48) {
      sum = sum * 10 + (number - 48);
    } else if (i == start && number == 43) {
      continue;
    } else if (i == start && number == 45) {
      sign = -1;
    } else if (number == 46) {
      break;
    } else {
      throw TypeError();
    }
  }

  return sum * sign;
}

dynamic _getNextData(Uint8List data, _Index index) {
  if (data[index.value] == 100) {
    return _dictionary(data, index);
  } else if (data[index.value] == 108) {
    return _list(data, index);
  } else if (data[index.value] == 105) {
    return _integer(data, index);
  } else {
    return _string(data, index);
  }
}

class _Index {
  int value;
  _Index(this.value);
}
