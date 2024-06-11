import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:cashier_system/core/shared/custom_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarTitle("Invoices"),
      body: Row(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Container(
                    width: 793.70,
                    height: 1124,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          height: 122,
                          color: Colors.red[200],
                        ),
                        SizedBox(
                          width: Get.width,
                          height: 900,
                        ),
                        Container(
                          width: Get.width,
                          height: 100,
                          color: Colors.red[200],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: primaryColor,
                    child: TabBar(
                      dividerColor: primaryColor,
                      dividerHeight: 1,
                      unselectedLabelColor: white,
                      indicatorColor: secondColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      automaticIndicatorColorAdjustment: true,
                      labelColor: secondColor,
                      tabs: [
                        Tab(
                          icon: const Icon(
                            FontAwesomeIcons.a,
                            size: 20,
                            color: white,
                          ),
                          child: Text(
                            "A4 Recive".tr,
                            style: bodyStyle.copyWith(color: white),
                          ),
                        ),
                        Tab(
                          icon: const Icon(
                            FontAwesomeIcons.receipt,
                            size: 20,
                            color: white,
                          ),
                          child: Text("Mini Recive".tr,
                              style: bodyStyle.copyWith(color: white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
