import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_fast_widgets/src/splash/controller.dart';
import 'package:get/get.dart';

class SplashWidget extends StatelessWidget {
  final Widget home;
  // jump to home widget after initialized

  final Widget Function(BuildContext context) builder;
  // splash widget builder

  final bool skippable;
  // if this splash can skip or not

  const SplashWidget({
    Key? key,
    required this.home,
    required this.builder,
    this.skippable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        id: SplashController.initKey,
        init: SplashController(),
        builder: (controller) {
          if (controller.isInitialized.value) {
            return Scaffold(
              body: home,
            );
          }
          return Stack(
            children: [
              builder.call(context),
              skippable
                  ? Positioned(
                      right: 10,
                      // top: 10,
                      child: SafeArea(child: Obx(() {
                        return ElevatedButton(
                          onPressed: () {
                            controller.durationEnd();
                          },
                          child:
                              Text("跳过 ${controller.duration.value ~/ 1000}s"),
                        );
                      })))
                  : Container()
            ],
          );
        });
  }
}

class CoupleSplashWidget extends SplashWidget {
  CoupleSplashWidget({
    Key? key,
    required Widget home,
    bool skippable = false,
  }) : super(
          key: key,
          home: home,
          builder: (context) => Container(
            color: Colors.green,
          ),
          skippable: skippable,
        );
}

Widget loadImage(String src, {BoxFit fit: BoxFit.cover}) {
  if (src.startsWith('/')) {
    return Image.file(File(src), fit: fit);
  } else if (src.startsWith('http')) {
    return Image.network(
      src,
      fit: fit,
      // progressIndicatorBuilder: (context, url, downloadProgress) =>
      //     CircularProgressIndicator(value: downloadProgress.progress),
    );
  } else {
    return Image.asset(src, fit: fit);
  }
}

class ImageSplashWidget extends SplashWidget {
  ImageSplashWidget({
    Key? key,
    required Widget home,
    String? image,
    Widget Function(BuildContext context)? builder,
    bool skippable = true,
  })  : assert(image != null || builder != null,
            "image and builder cant both be null"),
        super(
          key: key,
          home: home,
          builder: (context) => SizedBox(
              width: MediaQuery.of(context).size.width, // 屏幕宽度
              height: MediaQuery.of(context).size.height, // 屏幕高度
              child: image != null ? loadImage(image) : builder!.call(context)),
          skippable: skippable,
        );
}
