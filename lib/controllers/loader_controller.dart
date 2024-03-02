import 'package:flutter/material.dart';

class LoaderController extends ChangeNotifier {
  /// private constructor
  LoaderController._();

  /// the one and only instance of this singleton
  static final instance = LoaderController._();

  // passes the instantiation to the _instance object
  factory LoaderController() {
    return instance;
  }

  bool _isLoading = false;

  show() {
    _isLoading = true;
    notifyListeners();
  }

  hide() {
    _isLoading = false;
    notifyListeners();
  }

  getLoader() {
    return _isLoading;
  }
}
