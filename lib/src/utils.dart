// See file LICENSE for more information.

library src.utils;

import "dart:typed_data";

void arrayCopy(Uint8List sourceArr, int sourcePos, Uint8List outArr, int outPos,
    int len) {
  for (int i = 0; i < len; i++) {
    outArr[outPos + i] = sourceArr[sourcePos + i];
  }
}

/// Decode a BigInt from bytes in big-endian encoding.
BigInt decodeBigInt(List<int> bytes) {
  BigInt result = new BigInt.from(0);
  for (int i = 0; i < bytes.length; i++) {
    result += new BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
  }
  return result;
}

var _byteMask = new BigInt.from(0xff);

/// Encode a BigInt into bytes using big-endian encoding.
Uint8List encodeBigInt(BigInt number) {
  // Not handling negative numbers. Decide how you want to do that.
  int size = (number.bitLength + 7) >> 3;
  var result = new Uint8List(size);
  for (int i = 0; i < size; i++) {
    result[size - i - 1] = (number & _byteMask).toInt();
    number = number >> 8;
  }
  return result;
}

bool constantTimeAreEqual(Uint8List expected, Uint8List supplied) {
  if (expected == null || supplied == null) {
    return false;
  }

  if (expected == supplied) {
    return true;
  }

  int len =
  (expected.length < supplied.length) ? expected.length : supplied.length;

  int nonEqual = expected.length ^ supplied.length;

  for (int i = 0; i != len; i++) {
    nonEqual |= (expected[i] ^ supplied[i]);
  }
  for (int i = len; i < supplied.length; i++) {
    nonEqual |= (supplied[i] ^ ~supplied[i]);
  }

  return nonEqual == 0;
}

bool constantTimeAreEqualOffset(int len, Uint8List a, int aOff, Uint8List b,
    int bOff) {
  if (null == a) {
    throw ArgumentError("'a' cannot be null");
  }
  if (null == b) {
    throw ArgumentError("'b' cannot be null");
  }
  if (len < 0) {
    throw ArgumentError("'len' cannot be negative");
  }
  if (aOff > (a.length - len)) {
    throw ArgumentError("'aOff' value invalid for specified length");
  }
  if (bOff > (b.length - len)) {
    throw ArgumentError("'bOff' value invalid for specified length");
  }

  int d = 0;
  for (int i = 0; i < len; ++i) {
    d |= (a[aOff + i] ^ b[bOff + i]);
  }
  return 0 == d;
}