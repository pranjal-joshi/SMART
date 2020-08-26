import 'dart:async';
import 'package:connectivity/connectivity.dart';

enum ConnectivityProviderResult {
  wifi,
  mobile,
  none,
}

class ConnectivityProvider {
  final _connectivityController =
      StreamController<ConnectivityProviderResult>();

  Stream<ConnectivityProviderResult> get connectivityStream =>
      _connectivityController.stream;

  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityProvider() {
    Connectivity()
        .checkConnectivity()
        .then((value) => _connectivityController.sink.add(_getResult(value)));
        
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((event) => _connectivityController.sink.add(_getResult(event)));
  }

  void disposeStream() {
    _connectivitySubscription.cancel();
    _connectivityController.close();
  }

  ConnectivityProviderResult _getResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectivityProviderResult.wifi;
        break;
      case ConnectivityResult.mobile:
        return ConnectivityProviderResult.mobile;
        break;
      default:
        return ConnectivityProviderResult.none;
    }
  }
}
