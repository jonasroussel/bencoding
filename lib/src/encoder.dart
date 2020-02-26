import 'dart:convert';
import 'dart:typed_data';

/// Encodes data in bencode.
Uint8List encode(dynamic data) {
  List<Uint8List> buffers = [];

  _addToBuffers(buffers, data);

  return Uint8List.fromList(buffers.expand((x) => x).toList());
}

/// Encodes data in bencode String.
String encodeToString(dynamic data) {
  return utf8.decode(encode(data));
}

Uint8List _string(String data) {
  return utf8.encode('${data.length}:$data');
}

Uint8List _integer(int data) {
  return utf8.encode('i${data}e');
}

List<Uint8List> _list(List data) {
  List<Uint8List> buffers = [
    Uint8List.fromList([108])
  ];

  for (var item in data) {
    if (item == null) continue;

    _addToBuffers(buffers, item);
  }

  buffers.add(Uint8List.fromList([101]));

  return buffers;
}

List<Uint8List> _dictionary(Map data) {
  List<Uint8List> buffers = [
    Uint8List.fromList([100])
  ];

  data.forEach((key, value) {
    if (value == null) return;

    buffers.add(_string(key));

    _addToBuffers(buffers, value);
  });

  buffers.add(Uint8List.fromList([101]));

  return buffers;
}

_addToBuffers(List<Uint8List> buffers, dynamic data) {
  if (data is String) {
    buffers.add(_string(data));
  } else if (data is int) {
    buffers.add(_integer(data));
  } else if (data is bool) {
    buffers.add(_integer(data ? 1 : 0));
  } else if (data is List) {
    buffers.addAll(_list(data));
  } else if (data is Map) {
    buffers.addAll(_dictionary(data));
  } else {
    throw TypeError();
  }
}
