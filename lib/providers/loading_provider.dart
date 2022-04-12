import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  bool loading = false;

  setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

}
