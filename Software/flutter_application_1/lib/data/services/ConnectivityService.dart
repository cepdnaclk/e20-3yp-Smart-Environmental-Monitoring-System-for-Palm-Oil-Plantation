import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
