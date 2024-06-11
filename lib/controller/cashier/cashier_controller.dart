import 'package:cashier_system/controller/cashier/cashier_constant_controller.dart';
import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/shared/custom_snack_bar.dart';
import 'package:cashier_system/data/model/cart_model.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_items.dart';
import 'package:cashier_system/data/model/invoice_model.dart';
import 'package:cashier_system/data/model/items_model.dart';
import 'package:cashier_system/data/model/locale/custom_selected_list_users.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashierController extends CashierConstantController {
  final FocusNode focusNode = FocusNode();
  final FocusNode focusNode2 = FocusNode();
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
      for (int i = 0; i <= cartData.length - 1; i++) {
        selectedRows.add(cartData[i].itemsId.toString());
      }
    }
    update();
  }

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

  void checkValueFunction() {
    checkValue = !checkValue;
    update();
  }

  //? Checking Selected Rows:
  void checkSelectedRows(bool value, int index) {
    if (value == true) {
      selectedRows.add(cartData[index].itemsId.toString());
    } else {
      selectedRows.removeWhere(
          (element) => element == cartData[index].itemsId.toString());
    }
    update();
  }

  //? Calculating Reminder Cart Money
  void calculateTotalCartPrice(String value) {
    totalPrice = 0;
    if (value == "") {
      totalPrice = 0;
    } else {
      totalPrice = int.parse(value) - cartTotalPrice < 0
          ? 0
          : int.parse(value) - cartTotalPrice;
    }
    update();
  }

  //? Total Items Row Price:
  double totalItemsPrice(int itemsPrice, int itemsCount, int itemsDiscount) {
    return itemsCount * (itemsPrice * ((100 - itemsDiscount) / 100));
  }

  //! Get Items For Search;
  getItems() async {
    var response = await sqlDb.getAllData("tbl_items");
    if (response['status'] == "success") {
      listdataSearch.clear();
      List responsedata = response['data'];
      listdataSearch.addAll(responsedata.map((e) => ItemsModel.fromJson(e)));
      for (int i = 0; i < listdataSearch.length; i++) {
        dropDownList.add(CustomSelectedListItems(
          name: listdataSearch[i].itemsName!,
          desc: listdataSearch[i].itemsDesc,
          value: listdataSearch[i].itemsId.toString(),
          price: listdataSearch[i].itemsSellingprice.toString(),
        ));
      }
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  //! Get Users For Cart Owner;
  getUsers() async {
    var response = await sqlDb.getAllData("tbl_users");
    if (response['status'] == "success") {
      listdataSearchUsers.clear();
      dropDownListUsers.clear();
      List responsedata = response['data'];
      listdataSearchUsers
          .addAll(responsedata.map((e) => UsersModel.fromJson(e)));
      for (int i = 0; i < listdataSearchUsers.length; i++) {
        dropDownListUsers.add(CustomSelectedListUsers(
          name: listdataSearchUsers[i].usersName!,
          address: listdataSearchUsers[i].usersAddress!,
          phone: listdataSearchUsers[i].usersPhone!,
          id: listdataSearchUsers[i].usersId!.toString(),
        ));
      }
      update();
    }
  }

  //! Add Items To Cart:
  addItemsToCart(String id, String cartNo) async {
    update();
    Map<String, dynamic> data = {
      "cart_number": cartNo,
      "cart_items_id": id,
      "cart_items_count": 1,
      "cart_create_date": currentTime,
    };
    var response = await sqlDb.insertData("tbl_cart", data);
    if (response > 0) {
      getCartData(myServices.systemSharedPreferences.getString(
        "cart_number",
      )!);
    } else {}
    update();
  }

  //! Get Cart Data:
  getCartData(String id) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await cashierClass.processCartData(id);
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        cartData.clear();
        pendedCarts.clear();
        cartsNumbers.clear();
        cartTotalPrice = 0;
        List responsedata = response["datacart"]['data'] ?? [];
        cartData.addAll(responsedata.map((e) => CartModel.fromJson(e)));
        pendedCarts = response["pended_carts"];
        cartsNumbers = response["carts_number"];
        cartItemsCount = response["cart_items_count"];
        cartTotalCostPrice = response["total_cart_cost"];
        cartTotalPrice = response["total_cart_price"];
        // if (cartData.isNotEmpty) {
        //   for (int i = 0; i < cartData.length; i++) {
        //     double totalItemPrice = 0;
        //     if (cartData[i].cartItemGift != 1) {
        //       totalItemPrice = cartData[i].cartItemsCount! *
        //           cartData[i].itemsSellingprice! *
        //           ((100 - cartData[i].cartItemDiscount!) / 100);
        //       cartTotalPrice += totalItemPrice.toInt();
        //     }
        //   }
        //   cartTotalPrice = cartTotalPrice -
        //       cartData[0].cartDiscount! +
        //       int.parse(cartData[0].cartTax ?? "0");
        // }
      }
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  //! Item Increase
  cartItemIncrease(int itemsCount, String itemsid) async {
    update();
    var response = await cashierClass.increasData(itemsCount,
        myServices.systemSharedPreferences.getString("cart_number")!, itemsid);
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response > 0) {
        getCartData(myServices.systemSharedPreferences.getString(
          "cart_number",
        )!);
      } else {
        statusRequest = StatusRequest.failure;
      }
    }

    update();
  }

  //! Item Decrease:
  cartItemDecrease(int itemsCount, String itemsid) async {
    int response = 0;
    if (itemsCount > 0) {
      response = await cashierClass.decreaseData(
          itemsCount,
          myServices.systemSharedPreferences.getString(
            "cart_number",
          )!,
          itemsid);
    } else if (itemsCount == 0) {
      response = await cashierClass.deleteData(
          myServices.systemSharedPreferences.getString(
            "cart_number",
          )!,
          [itemsid]);
    }
    if (response > 0) {
      getCartData(myServices.systemSharedPreferences.getString(
        "cart_number",
      )!);
    }
    update();
  }

  //! Cart Delay:
  delayCart() async {
    // myServices.sharedPreferences.setString('cart_number', "1");
    // await cashierClass.updateCartStatus(
    //     myServices.sharedPreferences.getString('cart_number')!);
    // await getCartData(myServices.sharedPreferences.getString('cart_number')!);
    createNewBill();
    update();
  }

  //! Discounting Cart Price
  dicountingItems(List<String> itemsId, String discountValue) async {
    if (formstate.currentState!.validate()) {
      var response = await cashierClass.discountingItems(
          myServices.sharedPreferences.getString('cart_number')!,
          discountValue,
          itemsId);
      if (response > 0) {
        await getCartData(
            myServices.sharedPreferences.getString('cart_number')!);
        Get.back();
        selectedRows.clear();
      }
    }
    update();
  }

  //! Percent Discount Cart:
  percentDiscounting(String discountValue) async {
    if (formstate.currentState!.validate()) {
      var response = await cashierClass.discountingCart(
          myServices.sharedPreferences.getString('cart_number')!,
          discountValue);
      if (response > 0) {
        await getCartData(
            myServices.sharedPreferences.getString('cart_number')!);
        Get.back();
        selectedRows.clear();
      }
    }
    update();
  }

  //! Update Cart Number By input number
  updateItemQuantity(List<String> itemsid, String itemCount) async {
    if (formstate.currentState!.validate()) {
      var response = await cashierClass.addItembyNum(
          myServices.systemSharedPreferences.getString(
            "cart_number",
          )!,
          itemCount,
          itemsid);
      if (response > 0) {
        getCartData(
            myServices.systemSharedPreferences.getString("cart_number")!);
        Get.back();
        selectedRows.clear();
      }
    }
    update();
  }

  //! Update Cart Items Number
  updateItemNumber(String itemsid, String itemCount) async {
    if (formstate.currentState!.validate()) {
      var response = await cashierClass.updateItemNumber(
          myServices.systemSharedPreferences.getString(
            "cart_number",
          )!,
          itemCount,
          itemsid);
      if (response > 0) {
        getCartData(
            myServices.systemSharedPreferences.getString("cart_number")!);
      }
    }
    update();
  }

  //! Cart Item Gift:
  cartItemGift(List<String> itemsid) async {
    var response = await cashierClass.cartItemGift(
        myServices.systemSharedPreferences.getString("cart_number")!,
        selectedRows);
    if (response > 0) {
      getCartData(myServices.systemSharedPreferences.getString("cart_number")!);
    }
    update();
  }

//! Delete Cart Item
  deleteCartItem(List<String> itemsid) async {
    var response = await cashierClass.deleteData(
        myServices.systemSharedPreferences.getString("cart_number")!, itemsid);
    if (response > 0) {
      getCartData(myServices.systemSharedPreferences.getString("cart_number")!);
    }
    update();
  }

//! Delete Cart
  deleteCart() async {
    var response = await cashierClass.deleteCart(
        myServices.systemSharedPreferences.getString("cart_number")!);
    if (response > 0) {
      int newCartNumber = cartsNumbers.firstWhere(
          (number) => !myServices.systemSharedPreferences
              .getString("cart_number")!
              .contains(number.toString()),
          orElse: () => 0);
      if (newCartNumber != 0) {
        myServices.systemSharedPreferences
            .setString("cart_number", newCartNumber.toString());
        getCartData(
            myServices.systemSharedPreferences.getString("cart_number")!);
      }
      getCartData(myServices.systemSharedPreferences.getString("cart_number")!);
    }
    update();
  }

//! Add Cart Owner
  cartOwnerName(
      String username, String phone, String address, String note) async {
    if (formstate.currentState!.validate()) {
      var response = await cashierClass.cartOwnerName(
          myServices.systemSharedPreferences.getString("cart_number")!,
          username,
          phone,
          address,
          note);
      if (response > 0) {
        getCartData(
            myServices.systemSharedPreferences.getString("cart_number")!);
        Get.back();
      }
    }
    update();
  }

//! Update Cart Owner
  cartOwnerNameUpdate(String name) async {
    var response = await cashierClass.cartOwnerNameUpdate(
        myServices.systemSharedPreferences.getString("cart_number")!, name);
    if (response > 0) {
      getCartData(myServices.systemSharedPreferences.getString("cart_number")!);
    }
    update();
  }

//! Cart Cash or Dept
  cartCashState(String state) async {
    var response = await cashierClass.cartCashState(
        myServices.systemSharedPreferences.getString("cart_number")!, state);
    if (response > 0) {
      getCartData(myServices.systemSharedPreferences.getString("cart_number")!);
    }
    update();
  }

//! Cart Tax
  cartTax(String tax) async {
    if (formstate.currentState!.validate()) {
      var response = await cashierClass.cartTax(
          myServices.systemSharedPreferences.getString("cart_number")!, tax);
      if (response > 0) {
        getCartData(
            myServices.systemSharedPreferences.getString("cart_number")!);
        Get.back();
      }
    }
    update();
  }

//! New Bill Function:
  createNewBill() {
    if (cartsNumbers.length < 100) {
      int newCartNumber = 0;
      for (int i = 1; i < 100; i++) {
        if (!cartsNumbers.contains(i)) {
          newCartNumber = i;
          break;
        }
      }
      myServices.systemSharedPreferences
          .setString("cart_number", newCartNumber.toString());
      myServices.systemSharedPreferences.setBool("start_new_cart", true);
      getCartData(myServices.systemSharedPreferences.getString("cart_number")!);
    } else {
      customSnackBar(
          "Fail", "Please Finish Previous Card to start new one", true);
    }
  }

  cartPayment(String userId, String tax, String discount, String price,
      String costPrice, String itemsNumber, String invoicePaymentMethod) async {
    int userIdResponse = await cashierClass.getUserId(userId);
    Map<String, dynamic> data = {
      "invoice_user_id": userIdResponse,
      "invoice_tax": tax,
      "invoice_discount": discount,
      "invoice_price": price,
      "invoice_cost": costPrice,
      "invoice_items_number": itemsNumber,
      "invoice_organizer":
          myServices.sharedPreferences.getString("admins_name"),
      "invoice_payment": invoicePaymentMethod,
      "invoice_createdate": currentTime,
    };
    var response = await cashierClass.cartPayment(data);
    if (response > 0) {
      int idResponse = await cashierClass.getMaxInvoiceId();
      Map<String, dynamic> inoiceData = {
        "cart_status": "done",
        "cart_orders": idResponse,
        "cart_number": 0
      };
      await sqlDb.updateData("tbl_cart", inoiceData,
          "cart_number = ${myServices.systemSharedPreferences.getString("cart_number")!}");

      // // Fetch the list of items and their counts from the order
      // List<Map<String, dynamic>> cartItems = await sqlDb.getData(
      //   "SELECT item_id, item_count FROM tbl_cart_items WHERE cart_number = ${myServices.systemSharedPreferences.getString("cart_number")!}"
      // );

      // // Update the item counts in tbl_count
      // for (var item in cartItems) {
      //   int itemId = item['item_id'];
      //   int orderItemCount = item['item_count'];

      //   await sqlDb.updateData(
      //     "tbl_count",
      //     {"item_count": "item_count - $orderItemCount"},
      //     "item_id = $itemId"
      //   );
      // }

      createNewBill();
      getMaxInvoiceNumber();
      getLastInvoices();
    }
    update();
  }

  getMaxInvoiceNumber() async {
    int response = await cashierClass.getMaxInvoiceId();
    if (response > 0) {
      maxInvoiceNumber = 0;
      maxInvoiceNumber = response + 1;
    }
  }

  getLastInvoices() async {
    var response = await cashierClass.lastInvoices();
    if (response != 'fail') {
      lastInvoices.clear();
      List responsedata = response ?? [];
      lastInvoices.addAll(responsedata.map((e) => InvoiceModel.fromJson(e)));
    }
    update();
  }

  updateInvoice(String cartOrdersId) async {
    myServices.systemSharedPreferences.setBool("start_new_cart", false);
    int newCartNumber = 0;
    for (int i = 1; i < 100; i++) {
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
        getCartData(
            myServices.systemSharedPreferences.getString("cart_number")!);
      }
    }
    getLastInvoices();
    update();
  }

  payUpdataleInvoice() async {
    if (cartData.isNotEmpty) {
      if (cartData[0].cartUpdate == 1) {
        await cartPayment(
          cartData[0].cartOwner!,
          cartData[0].cartTax ?? "0",
          cartData[0].cartDiscount!.toString(),
          cartTotalPrice.toString(),
          cartTotalCostPrice.toString(),
          cartItemsCount.toString(),
          cartData[0].cartCash == "0" ? "Dept" : "Cash",
        );
      }
    }
  }

  intialData() {
    getItems();
    getUsers();
    getCartData(
        myServices.systemSharedPreferences.getString("cart_number") ?? "1");
    calculateTotalCartPrice("");
    getMaxInvoiceNumber();
    getLastInvoices();
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
  }

  @override
  void onInit() {
    intialData();
    focusNode.requestFocus();
    focusNode2.requestFocus();
    super.onInit();
  }

  @override
  void dispose() {
    focusNode.dispose();
    focusNode2.dispose();
    dropDownName!.dispose();
    dropDownID!.dispose();
    itemsQuantity!.dispose();
    cartOwnerIdController!.dispose();
    cartOwnerNameController!.dispose();
    reminderController!.dispose();
    buttonActionsController!.dispose();
    usernameController!.dispose();
    addressController!.dispose();
    phoneController!.dispose();
    noteController!.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    payUpdataleInvoice();
    super.onClose();
  }
}
