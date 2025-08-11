import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/constant/imgaeasset.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/core/shared/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget child;

  const HandlingDataView({
    super.key,
    required this.statusRequest,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    switch (statusRequest) {
      case StatusRequest.loading:
        return const _StatusView(
          animation: AppImageAsset.loading,
          message: TextRoutes.loading,
        );
      case StatusRequest.offlineFailure:
        return const _StatusView(
          animation: AppImageAsset.noConnection,
          message: TextRoutes.noInternet,
        );
      case StatusRequest.serverException:
        return const _StatusView(
          animation: AppImageAsset.serverException,
          message: TextRoutes.serverFail,
        );
      case StatusRequest.noData:
        return const _StatusView(
          animation: AppImageAsset.noData,
          message: TextRoutes.noData,
        );
      case StatusRequest.success:
        return child;
      default:
        return child;
    }
  }
}

class _StatusView extends StatelessWidget {
  final String animation;
  final String message;

  const _StatusView({
    required this.animation,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: message == TextRoutes.loading
              ? const CircularProgressIndicator(
                  color: primaryColor,
                )
              : Lottie.asset(animation, width: 250, height: 250),
        ),
        verticalGap(),
        Text(
          message.tr,
          style: titleStyle.copyWith(color: primaryColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
