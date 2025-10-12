import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_check__state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectivityInitial()) {
    _checkInitialConnectivity();
    _monitorConnectivityChanges();
  }

  ConnectivityResult? _lastConnectivityResult;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Check connectivity when the app starts
  Future<void> _checkInitialConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      await _handleConnectivityChange([connectivityResult.first]);
    } catch (e) {
      if (!isClosed) {
        emit(ConnectivityDisconnected());
        log('Error during initial connectivity check: $e');
      }
    }
  }

  /// Monitor connectivity changes with debouncing
  void _monitorConnectivityChanges() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      await _handleConnectivityChange(result);
    });
  }

  /// Check actual internet availability
  Future<bool> _isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      log('Error checking internet availability: $e');
      return false;
    }
  }

  /// Handle connectivity changes
  Future<void> _handleConnectivityChange(
      List<ConnectivityResult> connectivityResults) async {
    final connectivityResult = connectivityResults.isNotEmpty
        ? connectivityResults.first
        : ConnectivityResult.none;

    if (connectivityResult != _lastConnectivityResult) {
      _lastConnectivityResult = connectivityResult;

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        final isInternetAvailable = await _isInternetAvailable();
        if (!isClosed) {
          if (isInternetAvailable) {
            emit(ConnectivityConnected());
            log('Connectivity: Connected with internet');
          } else {
            emit(ConnectivityDisconnected());
            log('Connectivity: Connected but no internet');
          }
        }
      } else {
        if (!isClosed) {
          emit(ConnectivityDisconnected());
          log('Connectivity: Disconnected');
        }
      }
    }
  }

  /// Cancel subscription when disposing the cubit
  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
