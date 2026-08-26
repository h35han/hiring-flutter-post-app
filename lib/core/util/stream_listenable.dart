import 'dart:async';

import 'package:flutter/foundation.dart';

class StreamListenable extends ChangeNotifier {
  late final StreamSubscription _subscription;

  StreamListenable(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
