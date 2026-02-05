import 'dart:async';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    _timer?.cancel();
  }

  bool get isActive => _timer?.isActive ?? false;

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

class Throttler {
  final int milliseconds;
  Timer? _timer;
  bool _isExecuting = false;

  Throttler({required this.milliseconds});

  void run(void Function() action) {
    if (_isExecuting) return;

    _isExecuting = true;
    action();

    _timer = Timer(Duration(milliseconds: milliseconds), () {
      _isExecuting = false;
    });
  }

  void reset() {
    _timer?.cancel();
    _isExecuting = false;
  }

  bool get isThrottling => _isExecuting;

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _isExecuting = false;
  }
}
