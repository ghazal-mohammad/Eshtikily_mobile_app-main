import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'AlertService.dart';

class LoginAttempt {
  String email;
  int attemptCount;
  DateTime lastAttempt;
  bool isLocked;
  DateTime? lockedUntil;

  LoginAttempt({
    required this.email,
    this.attemptCount = 0,
    DateTime? lastAttempt,
    this.isLocked = false,
    this.lockedUntil,
  }) : lastAttempt = lastAttempt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'attemptCount': attemptCount,
      'lastAttempt': lastAttempt.toIso8601String(),
      'isLocked': isLocked,
      'lockedUntil': lockedUntil?.toIso8601String(),
    };
  }

  factory LoginAttempt.fromJson(Map<String, dynamic> json) {
    return LoginAttempt(
      email: json['email'],
      attemptCount: json['attemptCount'],
      lastAttempt: DateTime.parse(json['lastAttempt']),
      isLocked: json['isLocked'],
      lockedUntil: json['lockedUntil'] != null ? DateTime.parse(json['lockedUntil']) : null,
    );
  }
}

class LoginProtectionService {
  static final Map<String, LoginAttempt> _loginAttempts = {};
  static const int _maxAttempts = 5;
  static const Duration _lockDuration = Duration(minutes: 15);
  static const Duration _minTimeBetweenAttempts = Duration(seconds: 3);
  static final Map<String, DateTime> _lastAttemptTime = {};
  static bool _isInitialized = false;

  static Completer<void>? _initCompleter;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    if (_initCompleter != null) {
      return _initCompleter!.future;
    }
    _initCompleter = Completer();

    await _loadAttempts();
    await _loadLastAttemptTimes();
    _isInitialized = true;

    debugPrint('✅ LoginProtectionService initialized');
    _initCompleter!.complete();
  }

  static Future<void> _saveAttempts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final attemptsJson = jsonEncode(_loginAttempts.map((key, value) => MapEntry(key, value.toJson())));
      await prefs.setString('login_attempts', attemptsJson);
      debugPrint('💾 Saved login attempts to storage');
    } catch (e) {
      debugPrint('❌ Error saving login attempts: $e');
    }
  }

  static Future<void> _loadAttempts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final attemptsJson = prefs.getString('login_attempts');

      if (attemptsJson != null && attemptsJson.isNotEmpty) {
        final Map<String, dynamic> attemptsMap = jsonDecode(attemptsJson);
        _loginAttempts.clear();

        attemptsMap.forEach((key, value) {
          try {
            _loginAttempts[key] = LoginAttempt.fromJson(value);
          } catch (e) {
            debugPrint('❌ Error parsing attempt for $key: $e');
          }
        });
        debugPrint('📥 Loaded ${_loginAttempts.length} login attempts from storage');
      }
    } catch (e) {
      debugPrint('❌ Error loading login attempts: $e');
    }
  }

  static Future<void> _saveLastAttemptTimes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timesJson = jsonEncode(_lastAttemptTime.map((key, value) => MapEntry(key, value.toIso8601String())));
      await prefs.setString('last_attempt_times', timesJson);
    } catch (e) {
      debugPrint('❌ Error saving last attempt times: $e');
    }
  }

  static Future<void> _loadLastAttemptTimes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timesJson = prefs.getString('last_attempt_times');

      if (timesJson != null && timesJson.isNotEmpty) {
        final Map<String, dynamic> timesMap = jsonDecode(timesJson);
        _lastAttemptTime.clear();

        timesMap.forEach((key, value) {
          try {
            _lastAttemptTime[key] = DateTime.parse(value);
          } catch (e) {
            debugPrint('❌ Error parsing attempt time for $key: $e');
          }
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading last attempt times: $e');
    }
  }

  static bool isAccountLocked(String email) {
    final attempt = _loginAttempts[email];
    if (attempt == null) return false;

    if (attempt.isLocked && attempt.lockedUntil != null) {
      if (attempt.lockedUntil!.isAfter(DateTime.now())) {
        return true;
      } else {
        _resetAttempts(email);
        return false;
      }
    }
    return false;
  }

  static Duration getRemainingLockTime(String email) {
    final attempt = _loginAttempts[email];
    if (attempt == null || !attempt.isLocked || attempt.lockedUntil == null) {
      return Duration.zero;
    }

    final now = DateTime.now();
    final remaining = attempt.lockedUntil!.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  static String formatRemainingTime(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')} دقيقة';
    }
    return '${duration.inSeconds} ثانية';
  }

  static bool isTooFast(String email) {
    final lastTime = _lastAttemptTime[email];
    if (lastTime == null) return false;

    final timeSinceLastAttempt = DateTime.now().difference(lastTime);
    return timeSinceLastAttempt < _minTimeBetweenAttempts;
  }

  static Future<void> recordFailedAttempt(String email) async {
    await initialize();

    var attempt = _loginAttempts[email] ?? LoginAttempt(email: email);

    debugPrint('=== LOGIN PROTECTION DEBUG ===');
    debugPrint('Email: $email');
    debugPrint('Previous attempts: ${attempt.attemptCount}');

    attempt.attemptCount++;
    attempt.lastAttempt = DateTime.now();

    debugPrint('New attempt count: ${attempt.attemptCount}');

    _handleSecurityAlerts(email, attempt.attemptCount);

    if (attempt.attemptCount >= _maxAttempts) {
      debugPrint('🔒 ACCOUNT LOCKED - Reached max attempts');
      attempt.isLocked = true;
      attempt.lockedUntil = DateTime.now().add(_lockDuration);
      _sendLockoutNotification(email);
    } else {
      debugPrint('⚠️ Attempt recorded, not locked yet');
    }

    _loginAttempts[email] = attempt;
    _lastAttemptTime[email] = DateTime.now();

    await _saveAttempts();
    await _saveLastAttemptTimes();

    debugPrint('==============================');
  }

  static void _handleSecurityAlerts(String email, int attemptCount) {
    debugPrint('🔄 Handling security alerts for attempt: $attemptCount');

    switch (attemptCount) {
      case 2:
        debugPrint('📧 Sending failed login alert for attempt 2');
        AlertService.sendFailedLoginAlert(email, attemptCount);
        break;
      case 3:
        debugPrint('📧 Sending suspicious activity alert for attempt 3');
        AlertService.sendSuspiciousActivityAlert(email, attemptCount);
        break;
      case 4:
        debugPrint('📧 Sending failed login alert for attempt 4');
        AlertService.sendFailedLoginAlert(email, attemptCount);
        break;
      default:
        debugPrint('📝 No alert for attempt: $attemptCount');
    }
  }

  static void _sendLockoutNotification(String email) {
    debugPrint('🔐 Sending account locked notification for: $email');
    AlertService.sendAccountLockedAlert(email);
  }

  static Future<void> recordSuccessfulAttempt(String email) async {
    await initialize();

    debugPrint('✅ Login successful - Resetting attempts for: $email');
    await _resetAttempts(email);
  }

  static Future<void> recordAttemptTime(String email) async {
    await initialize();

    _lastAttemptTime[email] = DateTime.now();
    await _saveLastAttemptTimes();
    debugPrint('⏰ Recorded attempt time for: $email');
  }

  static Future<void> _resetAttempts(String email) async {
    _loginAttempts.remove(email);
    _lastAttemptTime.remove(email);

    await _saveAttempts();
    await _saveLastAttemptTimes();

    debugPrint('🔄 Reset login attempts for: $email');
  }

  static int getRemainingAttempts(String email) {
    final attempt = _loginAttempts[email];
    if (attempt == null) return _maxAttempts;
    return _maxAttempts - attempt.attemptCount;
  }

  static void debugAccountStatus(String email) {
    final attempt = _loginAttempts[email];
    if (attempt == null) {
      debugPrint('🔍 No login attempts recorded for: $email');
      return;
    }

    debugPrint('=== ACCOUNT STATUS DEBUG ===');
    debugPrint('Email: $email');
    debugPrint('Attempts: ${attempt.attemptCount}/$_maxAttempts');
    debugPrint('Is Locked: ${attempt.isLocked}');
    debugPrint('Locked Until: ${attempt.lockedUntil}');
    debugPrint('Remaining Time: ${getRemainingLockTime(email)}');
    debugPrint('Remaining Attempts: ${getRemainingAttempts(email)}');
    debugPrint('============================');
  }

  static void debugAllAccounts() {
    debugPrint('=== ALL ACCOUNTS STATUS ===');
    _loginAttempts.forEach((email, attempt) {
      debugPrint('Email: $email, Attempts: ${attempt.attemptCount}, Locked: ${attempt.isLocked}');
    });
    debugPrint('===========================');
  }

  static Future<void> cleanupOldData() async {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    _loginAttempts.forEach((email, attempt) {
      if (now.difference(attempt.lastAttempt) > const Duration(hours: 24)) {
        keysToRemove.add(email);
      }
    });

    for (final email in keysToRemove) {
      _loginAttempts.remove(email);
      _lastAttemptTime.remove(email);
    }

    if (keysToRemove.isNotEmpty) {
      await _saveAttempts();
      await _saveLastAttemptTimes();
      debugPrint('🧹 Cleaned up ${keysToRemove.length} old login attempts');
    }
  }
}
