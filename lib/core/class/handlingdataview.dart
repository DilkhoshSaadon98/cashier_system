import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/linkapi.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final int flex;
  final Widget widget;
  const HandlingDataView(
      {super.key,
      required this.statusRequest,
      required this.widget,
      required this.flex});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Expanded(
            flex: flex,
            child: Container(
                color: white,
                alignment: Alignment.center,
                child: const Text("Loading")),
          )
        : statusRequest == StatusRequest.offlinefailure
            ? Expanded(
                flex: flex,
                child: Container(
                    color: white,
                    alignment: Alignment.center,
                    child: const Text("Off line")),
              )
            : statusRequest == StatusRequest.failure
                ? Expanded(
                    flex: flex,
                    child: Container(
                        color: white,
                        alignment: Alignment.center,
                        child: const Text("Failure")),
                  )
                : statusRequest == StatusRequest.none
                    ? Expanded(
                        flex: flex,
                        child: Container(
                            color: white,
                            alignment: Alignment.center,
                            child: const Text("No Data")),
                      )
                    : widget;
  }
}

class HandlingDataRequest extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  const HandlingDataRequest(
      {super.key, required this.statusRequest, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Container(
            height: Get.height,
            alignment: Alignment.center,
            child: Lottie.asset(AppImageAsset.loading, width: 250, height: 250))
        : statusRequest == StatusRequest.offlinefailure
            ? SizedBox(
                height: Get.height,
                child: Center(
                    child: Image.asset(AppImageAsset.noConnection,
                        width: 250, height: 250)),
              )
            : statusRequest == StatusRequest.serverfailure
                ? Container(
                    height: Get.height,
                    alignment: Alignment.center,
                    child: Center(
                        child: Image.asset(AppImageAsset.serverFail,
                            width: 250, height: 250)),
                  )
                : statusRequest == StatusRequest.failure
                    ? Container(
                        height: Get.height,
                        alignment: Alignment.center,
                        child: Center(
                          child: Image.network(
                            "${AppLink.imagesConstant}no_data.gif",
                            width: 250,
                            height: 250,
                          ),
                        ),
                      )
                    : widget;
  }
}
