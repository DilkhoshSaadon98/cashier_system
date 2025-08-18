import 'package:cashier_system/controller/cashier/cashier_constant_controller.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/cart_model.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:cashier_system/data/model/invoice_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_users.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../data/model/categories_model.dart';

class CashierController extends CashierConstantController {
  //? show grid data view (items in image)
  bool showGridData =
      myServices.systemSharedPreferences.getBool("menu_expand") ?? true;
  switchShowGridData() {
    showGridData = !showGridData;
    myServices.systemSharedPreferences.setBool("menu_expand", showGridData);
    update();
  }

  int gridExpand =
      myServices.systemSharedPreferences.getInt("menu_expand_value") ?? 1;
  changeGridExpanded() {
    if (showGridData) {
      gridExpand++;
      if (gridExpand > 3) {
        gridExpand = 1;
      }
    }
    myServices.systemSharedPreferences.setInt("menu_expand_value", gridExpand);
    update();
  }

  bool autoPrint = true;

  void autoPrintChange(value) {
    autoPrint = value;
    myServices.systemSharedPreferences.setBool("auto_print", value);
    update();
  }

  //? Show Button List (Mobile Platform)
  void expandContainer() {
    isExpanded = !isExpanded;
    update();
  }

  bool isCategoriesSearchExpanded = false;
  void expandCategoriesSearch() {
    isCategoriesSearchExpanded = !isCategoriesSearchExpanded;
    update();
  }

  bool isItemsSearchExpanded = false;
  void expandItemsSearch() {
    isItemsSearchExpanded = !isItemsSearchExpanded;
    update();
  }

  bool isBarcodeScanning = true;
  final List<String> dropdownItems = [];

  //? Check if an item is selected
  bool isSelected(int itemsId) {
    return selectedRows.contains(itemsId);
  }

  //? Select or deselect an item
  void selectItem(int itemsId, bool? selected) {
    if (selected == true) {
      selectedRows.add(itemsId);
    } else {
      selectedRows.remove(itemsId);
    }
    update();
  }

//? Select or De-Select Items
  void toggleRowSelection(int index) {
    if (selectedRows.contains(index)) {
      selectedRows.remove(index);
    } else {
      selectedRows.add(index);
    }
    update();
  }

//? Hovering Buttons:
  void setHoverState(int index, bool isHovered) {
    hoverStates[index] = isHovered;
    update();
  }

//? Selecting Table Rows:
  void selectAllRows() {
    if (selectedRows.length == cartData.length) {
      selectedRows.clear();
    } else {
      selectedRows = cartData.map((item) => item.cartItemsId).toList();
    }
    update();
  }

//? Switch Between Carts Based on input number:
  void navigateToCart(int cartIndex) {
    if (cartIndex >= 0 && cartIndex < cartsNumbers.length) {
      int cartNumber = cartsNumbers[cartIndex];
      // Logic to navigate to the cart with the specified number
      myServices.systemSharedPreferences.setBool("start_new_cart", false);
      myServices.systemSharedPreferences
          .setString("cart_number", cartNumber.toString());
      getCartData(cartNumber.toString());
      selectedRows.clear();
    }
  }

//? Switch Between Current user Account and add new account:
  void checkValueFunction() {
    checkValue = !checkValue;
    update();
  }

//? Checking Selected Rows:
  void checkSelectedRows(bool value, int index) {
    int itemId = cartData[index].cartItemsId;
    if (value) {
      if (!selectedRows.contains(itemId)) {
        selectedRows.add(itemId);
      }
    } else {
      selectedRows.remove(itemId);
    }
    update();
  }

  //? Calculating Reminder Cart Money
  Future<void> calculateTotalCartPrice(String value) async {
    double enteredValue = 0.0;
    try {
      if (value.isNotEmpty) {
        enteredValue = double.parse(value);
      }
    } catch (e) {
      enteredValue = 0.0;
    }
    if (enteredValue < cartTotalPrice) {
      totalPrice = 0;
    } else {
      totalPrice = enteredValue - cartTotalPrice;
    }

    update();
  }

//? Total Items Row Price:
  double totalItemsPrice(double itemsPrice, int itemsCount, int itemsDiscount) {
    double discountFactor = (100 - itemsDiscount) / 100;
    return itemsCount * (itemsPrice * discountFactor);
  }

//? Get Items For Search;
  Future<void> getItems(
      {bool isInitialSearch = false, bool? calculateData = false}) async {
    if (isLoading) return;
    try {
      if (isInitialSearch) {
        currentPage = 0;
        listDataSearch.clear();
        dataItem.clear();
        dropDownList.clear();
      }

      isLoading = true;

      var response = await itemsClass.searchItemsData(
        itemsNo: itemsBarcodeController.text.isNotEmpty
            ? itemsBarcodeController.text
            : null,
        itemsName: itemsNameController.text.isNotEmpty
            ? itemsNameController.text
            : null,
        itemsCount: itemsCountController.text.isNotEmpty
            ? itemsCountController.text
            : null,
        itemsSelling: itemsSellingPriceController.text.isNotEmpty
            ? itemsSellingPriceController.text
            : null,
        itemsCategories:
            catNameController.text.isNotEmpty ? catNameController.text : null,
        itemsDesc: itemsDescControllerController.text.isNotEmpty
            ? itemsDescControllerController.text
            : null,
        offset: currentPage * itemsPerPage,
        limit: itemsPerPage,
      );
      if (response['data'].length > 0) {
        dropDownList.clear();
        List responsedata = response['data'];
        if (responsedata.isNotEmpty) {
          currentPage++;
          listDataSearch.addAll(responsedata.map((e) => ItemsModel.fromMap(e)));
          dataItem.addAll(responsedata.map((e) => ItemsModel.fromMap(e)));
        }
        for (int i = 0; i < listDataSearch.length; i++) {
          dropDownList.add(CustomSelectedListItems(
            name: listDataSearch[i].itemsName,
            desc: listDataSearch[i].itemsDescription,
            value: listDataSearch[i].itemsId.toString(),
            price: listDataSearch[i].itemsSellingPrice.toString(),
          ));
        }
      } else if (isInitialSearch) {
        //  showErrorDialog("", title: "Error", message: "No data");
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.noData);
    } finally {
      isLoading = false;
      update();
    }
  }

  bool isSearch = false;
  TextEditingController? search;
  //!Get Categories data:
  getCategoriesData({String? searchValue}) async {
    try {
      var response = await sqlDb.getAllData("tbl_categories",
          where: searchValue == null
              ? "1==1"
              : "categories_name LIKE '%$searchValue%'");

      if (response['status'] == "success") {
        categoriesData.clear();
        List dataList = response['data'];
        categoriesData.addAll(dataList.map((e) => CategoriesModel.fromJson(e)));
      } else {
        showErrorSnackBar(TextRoutes.failDuringFetchData);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    } finally {
      update();
    }
  }

  //? Get Items By ID;
  Future<void> getItemsById(int id) async {
    try {
      var response =
          await sqlDb.getAllData("itemsView", where: "item_id = $id");
      if (response['status'] == "success") {
        dataItem.clear();
        List responsedata = response['data'];
        dataItem.addAll(responsedata.map((e) => ItemsModel.fromMap(e)));
      } else {
        showErrorSnackBar(TextRoutes.failDuringFetchData);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.errorFetchingItemsData);
      dataItem.clear();
    } finally {
      update();
    }
  }

//? Get Users For Cart Owner;
  Future<void> getUsers() async {
    try {
      var response = await sqlDb.getAllData("view_customers_details");
      if (response['status'] == "success") {
        listDataSearchUsers.clear();
        dropDownListUsers.clear();
        List responsedata = response['data'] ?? [];
        listDataSearchUsers
            .addAll(responsedata.map((e) => UsersModel.fromJson(e)));
        for (int i = 0; i < listDataSearchUsers.length; i++) {
          dropDownListUsers.add(CustomSelectedListUsers(
            name: listDataSearchUsers[i].usersName,
            address: listDataSearchUsers[i].usersAddress,
            phone: listDataSearchUsers[i].usersPhone,
            id: listDataSearchUsers[i].usersId.toString(),
          ));
        }
      } else {
        showErrorSnackBar(TextRoutes.noDataFound);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.exceptionGettingUsers);
      listDataSearchUsers.clear();
      dropDownListUsers.clear();
    } finally {
      update();
    }
  }

  bool showDialog = true;
  //? Add Items To Cart:
  Future<void> addItemsToCart(String id, String cartNo,
      {String? barcode}) async {
    try {
      var response = await sqlDb.getData('''
    SELECT cart_items_count, cart_items_id FROM view_cart 
    WHERE cart_number = '$cartNo' 
    AND (item_barcode LIKE '%$barcode%' OR cart_items_id = '$id')
  ''');

      if (response.length > 0) {
        var cartItemsCount = response[0]['cart_items_count'];
        var cartItemsId = response[0]['cart_items_id'];

        var itemCountResponse = await sqlDb.getData('''
      SELECT item_count FROM tbl_items 
      WHERE item_id = '$cartItemsId'
    ''');
        dynamic totalItemCount = itemCountResponse[0]['item_count'];
        if (cartItemsCount + 1 > totalItemCount) {
          if (showDialog) {
            showErrorSnackBar(TextRoutes.emptyStock);
            showDialog = false;
          }
        }
        await cashierClass.increaseData(cartItemsCount, cartNo, cartItemsId);
      } else {
        // ignore: prefer_typing_uninitialized_variables
        var idResponse;
        if (id == "_") {
          idResponse = await sqlDb.getData('''
        SELECT item_id, item_count FROM tbl_items 
        WHERE item_barcode LIKE '%$barcode%'
      ''');
          if (idResponse.isNotEmpty) {
            id = idResponse[0]['item_id'].toString();
            Map<String, dynamic> data = {
              "cart_number": cartNo,
              "cart_items_id": id,
              "cart_items_count": 1,
              "cart_create_date": currentTime,
            };
            if (idResponse[0]['item_count']) {
              if (showDialog) {
                showErrorSnackBar(TextRoutes.emptyStock);
                showDialog = false;
              }
            }
            await sqlDb.insertData("tbl_cart", data);
          }
        } else {
          Map<String, dynamic> data = {
            "cart_number": cartNo,
            "cart_items_id": id,
            "cart_items_count": 1,
            "cart_create_date": currentTime,
          };
          await sqlDb.insertData("tbl_cart", data);
        }
      }
      getCartData(myServices.systemSharedPreferences.getString("cart_number")!);
    } catch (e) {
      showErrorDialog(
        e.toString(),
        message: TextRoutes.exceptionAddingItemToCart,
      );
    } finally {
      update();
    }
  }

  //! Get Cart Data:
  Future<void> getCartData(String id) async {
    try {
      var response = await cashierClass.processCartData(id);
      if (response['status'] == "success") {
        cartData.clear();
        pendedCarts.clear();
        cartsNumbers.clear();
        cartTotalPrice = 0.0;
        cartItemsCount = 0;

        List responsedata = response["data_cart"]['data'] ?? [];
        cartData.addAll(
          responsedata.map((e) {
            final mapData = Map<String, dynamic>.from(e);
            return CartModel.fromJson(mapData);
          }),
        );

        pendedCarts = response["pended_carts"] ?? [];
        cartsNumbers = response["carts_number"] ?? [];
        cartItemsCount = response["cart_items_count"] ?? 0;
        cartTotalCostPrice = response["total_cart_cost"] ?? 0.0;

        if (cartData.isNotEmpty) {
          for (var item in cartData) {
            if (item.cartItemGift != 1) {
              double itemPrice = (item.cartItemsPrice == 0.0)
                  ? item.itemsSellingPrice
                  : item.cartItemsPrice;

              double totalItemPrice = item.cartItemsCount * itemPrice;

              cartTotalPrice += totalItemPrice.toInt();
            }
          }

          double discount =
              double.tryParse(cartData[0].cartDiscount.toString()) ?? 0.0;
          int percentageDiscount = cartData[0].cartItemDiscount.toInt();
          double calculatedPercentageDiscount =
              (cartTotalPrice * (percentageDiscount / 100));
          double tax = cartData[0].cartTax;
          cartTotalPrice =
              (cartTotalPrice - calculatedPercentageDiscount - discount + tax);
        }
      } else {
        showErrorSnackBar(TextRoutes.failedToLoadCartData);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.exceptionGettingCartData);
    } finally {
      update(); // refresh UI
    }
  }

  //? Update Items Details:
  Future<void> updateItemDetails(int itemsId, int cartNumber,
      double sellingPrice, String unitName, double unitFactor) async {
    try {
      Map<String, dynamic> data = {
        "cart_item_price": sellingPrice,
        "item_unit": unitName,
        "item_unit_factor": unitFactor,
      };
      var response = await sqlDb.updateData("tbl_cart", data,
          "cart_items_id = $itemsId AND cart_number = $cartNumber");
      if (response > 0) {
        getCartData(cartNumber.toString());
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          title: "Error", message: "Error updating item price");
    } finally {
      update();
    }
  }

  //? Item Increase
  Future<void> cartItemIncrease(int itemsCount, int itemsId) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }
      var response =
          await cashierClass.increaseData(itemsCount, cartNumber, itemsId);
      if (response! > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.exceptionIncreasingItemCount);
      }
    } catch (e) {
      // showErrorDialog(
      //   e.toString(),
      //   message: TextRoutes.exceptionIncreasingItemCount,
      // );
      showErrorDialog(e.toString(),
          title: "Error", message: "Error increasing data");
    } finally {
      update();
    }
  }

  //? Item Decrease
  Future<void> cartItemDecrease(int itemsCount, int itemsId) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }
      int response;

      if (itemsCount > 1) {
        response =
            await cashierClass.decreaseData(itemsCount, cartNumber, itemsId);
      } else if (itemsCount == 1) {
        response = await cashierClass.deleteData(cartNumber, [itemsId]);
      } else {
        return;
      }

      if (response > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.failedUpdateItemCount);
      }
    } catch (e) {
      showErrorDialog(
        e.toString(),
        message: TextRoutes.exceptionUpdatingItem,
      );
    } finally {
      update();
    }
  }

  //? Cart Delay
  Future<void> delayCart() async {
    try {
      await createNewBill();
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.exceptionDelayingCart);
    } finally {
      update();
    }
  }

  //? Percentage Discounting Cart Price
  Future<void> percentageDiscountingItems(
      List<int> itemsId, String discountValue) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }

      var response = await cashierClass.percentageDiscountingItems(
          cartNumber, discountValue, itemsId);

      if (response > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.exceptionApplyingPercentageDiscount);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.exceptionApplyingPercentageDiscount);
    } finally {
      update();
    }
  }

  //? Discount Cart By Value
  Future<void> cartDiscountingByValue(String discountValue) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }

      var response =
          await cashierClass.discountingCart(cartNumber, discountValue);

      if (response > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.errorApplyingCartDiscount);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.errorApplyingCartDiscount);
    } finally {
      update();
    }
  }

  //? updateItemPrice
  void updateItemPrice(List<int> itemsId, String itemPrice) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }
      var response =
          await cashierClass.updateItemPrice(cartNumber, itemPrice, itemsId);

      if (response > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.failedUpdateItemCount);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.failedUpdateItemCount);
    } finally {
      update();
    }
  }

  //? Update Cart Number By Input Number
  Future<void> updateItemQuantity(List<int> itemsId, String itemCount) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }

      var response =
          await cashierClass.updateItemsCount(cartNumber, itemCount, itemsId);

      if (response > 0) {
        await getCartData(cartNumber);

        selectedRows.clear();
      } else {
        showErrorSnackBar(TextRoutes.failedUpdateItemCount);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.failedUpdateItemCount);
    } finally {
      update();
    }
  }

//? Update Cart Items Number
  Future<void> updateItemNumber(String itemsId, String itemCount) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }
      var response =
          await cashierClass.updateItemNumber(cartNumber, itemCount, itemsId);

      if (response > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.failedUpdateItemCount);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.failedUpdateItemCount);
    } finally {
      update();
    }
  }

//! Cart Item Gift
  Future<void> cartItemGift(List<int> itemsId) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }

      var response = await cashierClass.cartItemGift(cartNumber, selectedRows);

      if (response > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.exceptionApplyingItemsGift);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.exceptionApplyingItemsGift);
    } finally {
      update();
    }
  }

//? Delete Cart Item
  Future<void> deleteCartItem(List<int> itemsId) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }

      var response = await cashierClass.deleteData(cartNumber, itemsId);

      if (response > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.errorDeletingItems);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.errorDeletingItems);
    } finally {
      update();
    }
  }

//! Delete Cart
  Future<void> deleteCart() async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }
      var response = await cashierClass.deleteCart(cartNumber);
      if (response > 0) {
        int newCartNumber = cartsNumbers.firstWhere(
            (number) => number.toString() != cartNumber,
            orElse: () => 0);

        if (newCartNumber != 0) {
          await myServices.systemSharedPreferences
              .setString("cart_number", newCartNumber.toString());
          await getCartData(newCartNumber.toString());
        } else {
          delayCart();
        }
      } else {
        showErrorSnackBar(TextRoutes.errorDeletingCart);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.errorDeletingCart);
    } finally {
      update();
    }
  }

//? Add Cart Owner
  Future<void> cartOwnerName(
      String username, String phone, String address, String note) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (formState.currentState?.validate() ?? false) {
        if (cartNumber == null) {
          showErrorSnackBar(TextRoutes.cartNumberNotSet);
          return;
        }

        var response = await cashierClass.cartOwnerName(
            cartNumber, username, phone, address, note);

        if (response > 0) {
          await getCartData(cartNumber);
        } else {
          showErrorSnackBar(TextRoutes.exceptionAddingCartOwner);
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.exceptionAddingCartOwner);
    } finally {
      update();
    }
  }

//? Update Cart Owner
  Future<void> cartOwnerNameUpdate(String? userId) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }

      if (cartData.isNotEmpty) {
        var response =
            await cashierClass.cartOwnerNameUpdate(cartNumber, userId);
        if (response > 0) {
          showSuccessSnackBar(TextRoutes.dataUpdatedSuccess);
          await getCartData(cartNumber);
        } else {
          showErrorSnackBar(TextRoutes.errorUpdatingCartOwnerName);
        }
      } else {
        showErrorSnackBar(TextRoutes.emptyCart);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.errorUpdatingCartOwnerName);
    } finally {
      update();
    }
  }

//! Cart Cash or Debt State
  Future<void> cartCashState(String state) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }

      var response = await cashierClass.cartCashState(cartNumber, state);
      if (response > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.errorUpdatingCartCashState);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.errorUpdatingCartCashState);
    } finally {
      update();
    }
  }

//? Update Cart Tax
  Future<void> cartTax(String tax) async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }

      var response = await cashierClass.cartTax(cartNumber, tax);
      if (response > 0) {
        await getCartData(cartNumber);
      } else {
        showErrorSnackBar(TextRoutes.errorUpdatingCartTaxValue);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.errorUpdatingCartTaxValue);
    } finally {
      update();
    }
  }

  final List<int> fixedCartNumbers = List.generate(30, (index) => index + 1);
//? Create New Bill
  Future<void> createNewBill() async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }

      int? newCartNumber;
      for (int i = 1; i <= fixedCartNumbers.length; i++) {
        if (!cartsNumbers.contains(i)) {
          newCartNumber = i;
          break;
        }
      }

      if (newCartNumber == null) {
        showErrorSnackBar(TextRoutes.allCartFull);
        return;
      }

      await myServices.systemSharedPreferences
          .setString("cart_number", newCartNumber.toString());
      await myServices.systemSharedPreferences.setBool("start_new_cart", true);

      await getCartData(newCartNumber.toString());
    } catch (e) {
      showErrorDialog(
        e.toString(),
        message: TextRoutes.exceptionCreatingNewBill,
      );
    } finally {
      update();
    }
  }

  //? Cart Payment Method:
  Future<void> cartPayment(
    int? userId,
    double tax,
    String discount,
    String price,
    String costPrice,
    String itemsNumber,
    String invoicePaymentMethod,
  ) async {
    final cartNumber =
        myServices.systemSharedPreferences.getString("cart_number")!;
    try {
      int boxAccountId = 7;
      int lossOfSaleAccountId = 87;
      int inventoryAccountId = 10;
      int salesAccountId = 34;
      int costOfSalesAccountId = 44;
      double cost = double.parse(costPrice);
      double sellPrice = double.parse(price);

      Map<String, dynamic> invoiceData = {
        "invoice_user_id": userId,
        "invoice_tax": tax,
        "invoice_discount": discount,
        "invoice_price": price,
        "invoice_cost": costPrice,
        "invoice_items_number": itemsNumber,
        "invoice_organizer":
            myServices.sharedPreferences.getString("admins_name") ??
                TextRoutes.noData,
        "invoice_type": 'sale',
        "invoice_status": 'active',
        "invoice_payment": invoicePaymentMethod,
        "invoice_createdate": currentTime,
      };

      // Insert invoice
      var invoiceIdResponse = await cashierClass.cartPayment(invoiceData);

      String transactionNumber = "IN-$invoiceIdResponse";
      // 1. تسجيل عملية البيع (دفتر المبيعات)
      await sqlDb.insertData('tbl_transactions', {
        'transaction_type': 'sale',
        'transaction_date': currentTime,
        'transaction_amount': sellPrice,
        'transaction_discount': discount,
        'transaction_note': 'فاتورة بيع رقم $invoiceIdResponse',
        'source_account_id': boxAccountId,
        'target_account_id': salesAccountId,
        'transaction_number': transactionNumber
      });

      // 2. تكلفة البضاعة المباعة
      await sqlDb.insertData('tbl_transactions', {
        'transaction_type': 'payment',
        'transaction_date': currentTime,
        'transaction_amount': cost,
        'transaction_note': 'تكلفة بضاعة فاتورة رقم $invoiceIdResponse',
        'source_account_id': inventoryAccountId,
        'target_account_id': costOfSalesAccountId,
        'transaction_number': transactionNumber
      });

      // 3. تسجيل الخسارة (إذا كانت)
      if (cost > sellPrice) {
        double loss = cost - sellPrice;
        await sqlDb.insertData('tbl_transactions', {
          'transaction_type': 'payment',
          'transaction_date': currentTime,
          'transaction_amount': loss,
          'transaction_note': 'خسارة بيع فاتورة رقم $invoiceIdResponse',
          'source_account_id': boxAccountId,
          'target_account_id': lossOfSaleAccountId,
          'transaction_number': transactionNumber
        });
      }

      // 4. تسجيل طريقة الدفع
      if (invoicePaymentMethod == "cash") {
        await sqlDb.insertData('tbl_transactions', {
          'transaction_type': 'receipt',
          'transaction_date': currentTime,
          'transaction_amount': sellPrice,
          'transaction_note': 'قبض نقدي فاتورة رقم $invoiceIdResponse',
          'source_account_id': boxAccountId,
          'target_account_id': salesAccountId,
          'transaction_number': transactionNumber
        });
      } else if (invoicePaymentMethod == "debt") {
        await sqlDb.insertData('tbl_transactions', {
          'transaction_type': 'receipt',
          'transaction_date': currentTime,
          'transaction_amount': sellPrice,
          'transaction_note': 'فاتورة على الحساب رقم $invoiceIdResponse',
          'source_account_id': userId,
          'target_account_id': salesAccountId,
          'transaction_number': transactionNumber
        });
      }
      // 5. تحديث المخزون
      if (invoiceIdResponse > 0) {
        List<Map<String, dynamic>> cartItems = await sqlDb.getData(
          "SELECT cart_items_id,item_unit_factor, cart_items_count FROM tbl_cart WHERE cart_number = $cartNumber",
        );
        for (var cartItem in cartItems) {
          int itemId = int.parse(cartItem['cart_items_id'].toString());
          double unitFactor = cartItem['item_unit_factor'] ?? 1;
          double quantitySold = cartItem['cart_items_count'] * unitFactor;

          Database? myDb = await sqlDb.db;
          await myDb!.rawUpdate(
            "UPDATE tbl_items SET item_count = item_count - $quantitySold WHERE item_id = $itemId",
          );
          await sqlDb.insertData("tbl_inventory_movements", {
            "item_id": itemId,
            "movement_type": 'sale',
            "quantity": quantitySold,
            "cost_price": cost,
            "sale_price": sellPrice,
            "movement_date": currentTime,
            "note": " عملية بيع فاتورة $invoiceIdResponse",
            "account_id": userId
          });
        }

        // تحديث حالة السلة
        int maxInvoiceId = await cashierClass.getMaxInvoiceId();
        await sqlDb.updateData(
          "tbl_cart",
          {
            "cart_status": "done",
            "cart_orders": maxInvoiceId,
            "cart_number": 0,
          },
          "cart_number = $cartNumber",
        );
        await createNewBill();
        await getMaxInvoiceNumber();
        await getLastInvoices();
        Get.back();
      } else {
        showErrorSnackBar(TextRoutes.errorProcessingCartPayment);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.errorProcessingCartPayment);
    } finally {
      update();
    }
  }

//? CashBack Function:
  Future<void> cashBack() async {
    try {
      String? cartNumber =
          myServices.systemSharedPreferences.getString("cart_number");
      if (cartNumber == null) {
        showErrorSnackBar(TextRoutes.cartNumberNotSet);
        return;
      }
      //? Retrieve items and quantities from the cart
      List<Map<String, dynamic>> cartItems = await sqlDb.getData(
        "SELECT cart_items_id,item_unit_factor, cart_items_count FROM tbl_cart WHERE cart_number = $cartNumber",
      );

      //? Update the item counts in the tbl_items table
      for (var cartItem in cartItems) {
        int itemId = int.parse(cartItem['cart_items_id'].toString());
        double unitFactor = cartItem['item_unit_factor'] ?? 1;
        double quantitySold = cartItem['cart_items_count'] * unitFactor;

        //? Increment the item count
        Database? myDb = await sqlDb.db;
        int response = await myDb!.rawUpdate(
          "UPDATE tbl_items SET item_count = item_count + $quantitySold WHERE item_id = $itemId",
        );
        if (response > 0) {
          int removeResponse =
              await sqlDb.deleteData("tbl_cart", "cart_number =$cartNumber");
          if (removeResponse > 0) {
            createNewBill();
          }
        }
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.errorDuringCashBack);
    } finally {
      update();
    }
  }

//? Get Max Invoice Number
  Future<void> getMaxInvoiceNumber() async {
    try {
      int response = await cashierClass.getMaxInvoiceId();
      if (response > 0) {
        maxInvoiceNumber = response + 1;
      } else {
        maxInvoiceNumber = 1;
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.errorGettingMaxInvoiceNumber);
      maxInvoiceNumber = 1;
    }
  }

//? Get Last Invoices
  Future<void> getLastInvoices() async {
    try {
      var response = await cashierClass.lastInvoices();
      if (response != 'fail') {
        lastInvoices.clear();
        List responsedata = response ?? [];
        lastInvoices.addAll(responsedata.map((e) => InvoiceModel.fromJson(e)));
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.errorFetchingLastInvoices);
    } finally {
      update();
    }
  }

  //? Update Invoice
  Future<void> updateInvoice(String cartOrdersId) async {
    try {
      myServices.systemSharedPreferences.setBool("start_new_cart", false);
      int newCartNumber = 1;
      for (int i = 1; i <= fixedCartNumbers.length; i++) {
        if (!cartsNumbers.contains(i)) {
          newCartNumber = i;
          break;
        }
      }
      int response =
          await cashierClass.updateInvoice(cartOrdersId, newCartNumber);
      if (response > 0) {
        int invoiceResponse =
            await cashierClass.removeUpdatedInvoice(cartOrdersId);
        if (invoiceResponse > 0) {
          myServices.systemSharedPreferences
              .setString("cart_number", newCartNumber.toString());
          await getCartData(
              myServices.systemSharedPreferences.getString("cart_number")!);
          await getLastInvoices();
        } else {
          showErrorSnackBar(TextRoutes.errorRemovingUpdatedInvoice);
        }
      } else {
        showErrorSnackBar(TextRoutes.failedToUpdateInvoice);
      }
    } catch (e) {
      showErrorDialog(e.toString(),
          message: TextRoutes.errorRemovingUpdatedInvoice);
    } finally {
      update();
    }
  }

  //! Pay Invoice If it is in update state
  Future<void> payUpdatableInvoice() async {
    try {
      if (cartData.isNotEmpty && cartData[0].cartUpdate == 1) {
        await cartPayment(
          cartData[0].accountId!,
          cartData[0].cartTax,
          cartData[0].cartDiscount.toString(),
          cartTotalPrice.toString(),
          cartTotalCostPrice.toString(),
          cartItemsCount.toString(),
          cartData[0].cartCash == "0" ? TextRoutes.dept : TextRoutes.cash,
        );

        // if (cartTotalCostPrice > cartTotalPrice) {
        //   Map<String, dynamic> dataExport = {
        //     "export_supplier_id": cartData[0].cartOwnerId!,
        //     "export_amount": cartTotalCostPrice - cartTotalPrice,
        //     "export_account": "Cash Expenses",
        //     "export_note": "Cash Expenses of invoice($maxInvoiceNumber)",
        //     "export_cash_id": maxInvoiceNumber,
        //     "export_create_date": currentTime,
        //   };
        //   await sqlDb.insertData("tbl_export", dataExport);
        // }
        await getCartData(
            myServices.systemSharedPreferences.getString("cart_number")!);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.exceptionPayingInvoice);
    } finally {
      update();
    }
  }

  List<TextEditingController?> itemsController = [];
  initialData() async {
    dropDownName = TextEditingController();
    dropDownID = TextEditingController();
    itemsQuantity = TextEditingController();
    cartOwnerIdController = TextEditingController();
    cartOwnerNameController = TextEditingController();
    reminderController = TextEditingController();
    buttonActionsController = TextEditingController();
    usernameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    noteController = TextEditingController();

    await Future.wait([
      getItems(isInitialSearch: true),
      getCartData(
          myServices.systemSharedPreferences.getString("cart_number") ?? "1"),
      calculateTotalCartPrice(""),
      getMaxInvoiceNumber(),
    ]);
  }

//? go to items screen:
  goToItemsScreen() {
    String? cartNumber =
        myServices.systemSharedPreferences.getString("cart_number");
    if (cartNumber == null) {
      showErrorSnackBar(TextRoutes.cartNumberNotSet);
      return;
    }

    Get.toNamed(AppRoute.itemsViewScreen,
        arguments: {'show_add_cart': true, 'cart_number': cartNumber});
  }

  @override
  void onInit() async {
    initialData().then((_) => focusNode.requestFocus());
    getCategoriesData();
    super.onInit();
  }

  //! Dispose Controllers
  @override
  void dispose() {
    focusNode.dispose();
    itemsQuantity?.dispose();
    dropDownName?.dispose();
    dropDownID?.dispose();
    catName?.dispose();
    catID?.dispose();
    itemsNameController.dispose();
    itemsDescControllerController.dispose();
    itemsCountController.dispose();
    itemsSellingPriceController.dispose();
    itemsBuyingPriceController.dispose();
    itemsCostPriceController.dispose();
    itemsWholeSalePriceController.dispose();
    itemsTypeController.dispose();
    itemsTypeControllerId.dispose();
    itemsCategoriesControllerId.dispose();
    itemsCategoriesControllerName.dispose();
    itemsBarcodeController.dispose();
    catNameController.dispose();
    cartOwnerNameController?.dispose();
    cartOwnerIdController?.dispose();
    reminderController?.dispose();
    buttonActionsController?.dispose();
    usernameController?.dispose();
    addressController?.dispose();
    phoneController?.dispose();
    noteController?.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    // payUpdatableInvoice().then((_) => super.onClose());
  }
}
