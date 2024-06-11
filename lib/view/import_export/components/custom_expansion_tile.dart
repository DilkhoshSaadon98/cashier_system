import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomExpansionTileWidget extends StatelessWidget {
  final void Function() onTapSearch, onTapAdd;
  final Color backColor, searchColor, addColor;
  final String title;
  final bool expanded;
  const CustomExpansionTileWidget({
    super.key,
    required this.onTapSearch,
    required this.onTapAdd,
    required this.backColor,
    required this.searchColor,
    required this.addColor,
    required this.title,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backColor,
          border: Border.all(width: .5, color: white),
          borderRadius: BorderRadius.circular(5)),
      child: ExpansionTile(
        backgroundColor: backColor,
        initiallyExpanded: expanded,
        expansionAnimationStyle: AnimationStyle(
            curve: Curves.easeInCirc,
            duration: const Duration(milliseconds: 100)),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(3)),
        trailing: const Icon(
          Icons.arrow_drop_down_sharp,
          color: white,
        ),
        title: Text(title, style: titleStyle.copyWith(color: white)),
        children: [
          Container(
            color: searchColor,
            child: ListTile(
              title: Text('Search'.tr, style: bodyStyle.copyWith(color: white)),
              trailing: const Icon(
                Icons.search,
                color: white,
              ),
              onTap: onTapSearch,
            ),
          ),
          Container(
            color: addColor,
            child: ListTile(
              title: Text('Add'.tr, style: bodyStyle.copyWith()),
              trailing: Icon(
                Icons.add,
                color: primaryColor,
              ),
              onTap: onTapAdd,
            ),
          ),
        ],
      ),
    );
  }
}
