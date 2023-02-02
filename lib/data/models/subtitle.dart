import 'package:equatable/equatable.dart';

class Subtitle extends Equatable {
  final Duration startTime;
  final Duration endTime;
  final String text;
  final double? _position;
  final double? line;
  final double? size;
  final String? align;

  const Subtitle({
    required this.startTime,
    required this.endTime,
    required this.text,
    double? position,
    this.line,
    this.align,
    this.size,
  }) : _position = position;

  double? get position {
    if (_position != null) {
      return _position;
    } else {
      if (align != null) {
        switch (align) {
          case 'left':
          case 'start':
            return 0;
          case 'end':
          case 'right':
            return 100;
          default:
            return 50;
        }
      }
    }

    return null;
  }

  @override
  String toString() {
    return "position: $position, line: $line, align: $align, size: $size";
  }

  @override
  List<Object?> get props => [startTime, endTime, text];
}
