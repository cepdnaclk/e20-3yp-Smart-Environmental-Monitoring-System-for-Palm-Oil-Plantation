import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }


//   Stream<List<ConnectivityResult>> get onConnectivityChanged =>
//       _connectivity.onConnectivityChanged;

  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map((list) {
        // Return the first non-none result or fallback to none
        return list.firstWhere(
              (result) => result != ConnectivityResult.none,
          orElse: () => ConnectivityResult.none,
        );
      });

}
