import 'dart:async';

class SessionTimer {
  // Timer states
  static const String ready = 'READY';
  static const String inSession = 'IN_SESSION';
  static const String inBreak = 'IN_BREAK';
  static const String completed = 'COMPLETED';

  // Configuration variables
  int _roundDuration; // in minutes
  int _breakDuration; // in minutes
  int _totalRounds;
  int _currentRound = 0;

  // Timer variables
  Timer? _timer;
  int _remainingSeconds = 0;
  String _currentState = ready;

  // Callbacks
  Function(String state)? _stateChangeCallback;
  Function(int remainingSeconds)? _tickCallback;
  Function()? _sessionCompleteCallback;

  SessionTimer({
    required int roundDuration,
    required int breakDuration,
    required int totalRounds,
    Function(String state)? onStateChanged,
    Function(int remainingSeconds)? onTick,
    Function()? onSessionComplete,
  })  : _roundDuration = roundDuration,
        _breakDuration = breakDuration,
        _totalRounds = totalRounds {
    _stateChangeCallback = onStateChanged;
    _tickCallback = onTick;
    _sessionCompleteCallback = onSessionComplete;
  }

  // Getters
  String get currentState => _currentState;
  int get currentRound => _currentRound;
  int get totalRounds => _totalRounds;
  int get remainingSeconds => _remainingSeconds;
  int get roundDuration => _roundDuration;
  int get breakDuration => _breakDuration;

  // Format time as MM:SS
  String get formattedTime {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Start the session
  void startSession() {
    if (_currentState != ready) return;
    _currentRound = 1;
    _startRound();
  }

  // Start a work round
  void _startRound() {
    _currentState = inSession;
    _remainingSeconds = _roundDuration * 60;
    _stateChangeCallback?.call(_currentState);
    _startTimer();
  }

  // Start a break
  void _startBreak() {
    _currentState = inBreak;
    _remainingSeconds = _breakDuration * 60;
    _stateChangeCallback?.call(_currentState);
    _startTimer();
  }

  // Start the timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      _tickCallback?.call(_remainingSeconds);
      if (_remainingSeconds <= 0) {
        _handleTimerComplete();
      }
    });
  }

  // Handle when timer completes
  void _handleTimerComplete() {
    _timer?.cancel();

    if (_currentState == inSession) {
      if (_currentRound < _totalRounds) {
        _startBreak();
      } else {
        _completeSession();
      }
    } else if (_currentState == inBreak) {
      _currentRound++;
      _startRound();
    }
  }

  // Complete the session
  void _completeSession() {
    _sessionCompleteCallback?.call();
    _currentState = completed;
    _stateChangeCallback?.call(_currentState);
  }

  // Pause the timer
  void pause() {
    _timer?.cancel();
  }

  // Resume the timer
  void resume() {
    if (_remainingSeconds > 0) {
      _startTimer();
    }
  }

  // Reset the timer
  void reset() {
    _timer?.cancel();
    _currentState = ready;
    _currentRound = 0;
    _remainingSeconds = 0;
    _stateChangeCallback?.call(_currentState);
  }

  // Update configuration
  void updateConfiguration({
    int? roundDuration,
    int? breakDuration,
    int? totalRounds,
  }) {
    _roundDuration = roundDuration ?? _roundDuration;
    _breakDuration = breakDuration ?? _breakDuration;
    _totalRounds = totalRounds ?? _totalRounds;

    // _roundDuration = 1;
    // _breakDuration = 1;
    // _totalRounds = 5;
  }

  // Dispose resources
  void dispose() {
    _timer?.cancel();
  }
}
