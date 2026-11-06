/// Motion durations. Keep state feedback quick and large transitions calm.
abstract final class TomathicsDurations {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 320);
}
