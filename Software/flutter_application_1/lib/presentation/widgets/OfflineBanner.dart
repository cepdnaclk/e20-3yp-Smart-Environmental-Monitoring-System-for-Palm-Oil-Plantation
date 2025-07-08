import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;

  const OfflineBanner({super.key, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    return isOffline
        ? Container(
      color: Colors.red,
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        '⚠️ You are offline. Showing cached data.',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    )
        : const SizedBox.shrink();
  }
}
