import 'dart:async';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxBool isInitialized = false.obs;
  RxInt duration = 5000.obs;

  static String initKey = 'initialized';

  static SplashController? _instance;
  SplashController._() {
    listenDuration();
  }

  factory SplashController({int? maxDuration}) {
    _instance = _instance ?? SplashController._();
    if (maxDuration != null) {
      _instance!.duration.value = maxDuration;
    }
    return _instance!;
  }

  listenDuration() async {
    if (duration > 0) {
      duration -= 1000;
      Future.delayed(const Duration(seconds: 1), listenDuration);
    } else {
      durationEnd();
    }
  }

  durationEnd() {
    isInitialized.value = true;
    update([initKey]);
  }
}
