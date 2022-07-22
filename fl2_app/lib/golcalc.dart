import 'dart:ui';

class GolCalculator {
  final int _size;
  final List<List<int>> _startConfig;

  late List<List<bool>> _fields;

  GolCalculator(this._size, this._startConfig) {
    _fields = List.generate(_size, (i) => List.filled(_size, false));

    for (var sc in _startConfig) {
      if (sc.length == 2 && _checkSize(sc[0]) && _checkSize(sc[1])) {
        _fields[sc[0]][sc[1]] = true;
      }
    }
  }

  List<Offset> getOffsets() {
    final List<Offset> r = [];

    for (int x = 0; x < _size; x++) {
      for (int y = 0; y < _size; y++) {
        if (_fields[x][y]) {
          r.add(Offset(x.toDouble(), y.toDouble()));
        }
      }
    }

    return r;
  }

  void step() {
    final newFields = List.generate(_size, (i) => List.filled(_size, false));

    for (int x = 0; x < _size; x++) {
      for (int y = 0; y < _size; y++) {
        int nb = _countNeighbours(x, y);
        if (nb == 3) {
          newFields[x][y] = true;
        }
        if (nb == 2 && _fields[x][y]) {
          newFields[x][y] = true;
        }
      }
    }

    _fields = newFields;
  }

  int _countNeighbours(int x, int y) {
    int sum = 0;

    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) {
          continue;
        }
        if (_checkSize(x + i) && _checkSize(y + j) && _fields[x + i][y + j]) {
          sum++;
        }
      }
    }
    return sum;
  }

  bool _checkSize(int i) {
    return i >= 0 && i < _size;
  }
}
