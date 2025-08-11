import 'package:cashier_system/core/class/statusrequest.dart';
import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/functions/handing_data_controller.dart';
import 'package:cashier_system/core/functions/show_popup_menu.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/source/account_class.dart';
import 'package:cashier_system/data/source/clients_data.dart';
import 'package:cashier_system/data/source/users_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientsController extends GetxController {
  List<UsersModel> customersData = [];
  //! --------------------------------------------------------
  //? Scrolling Constants
  ScrollController scrollControllers = ScrollController();
  bool hasMoreData = true;
  int itemsPerPage = 50;
  int itemsOffset = 0;
  bool isLoading = false;
  bool showBackToTopButton = false;
  void initScrolls() {
    scrollControllers.addListener(() {
      bool shouldShow = scrollControllers.offset > 20;
      if (showBackToTopButton != shouldShow) {
        showBackToTopButton = shouldShow;
        update();
      }
    });
    scrollControllers.addListener(() {
      if (scrollControllers.position.pixels >=
          scrollControllers.position.maxScrollExtent) {
        if (!isLoading) {
          onSearchData(false)();
        }
      }
    });
  }

  //! --------------------------------------------------------
  //? Sorting Data
  bool isAccountFields = false;
  String selectedSortField = "id";
  bool sortAscending = true;
  void setAccountFields(bool value) {
    isAccountFields = value;
    update();
  }

  //? Sorting Function:
  void changeSortField(String field) {
    selectedSortField = field;
    onSearchData(true)();
    update();
  }

  //? Toggle Sorting Ascending/Descending:
  Future<void> toggleSortOrder() async {
    sortAscending = !sortAscending;
    await onSearchData(true)();

    update();
  }

  List<Map<String, dynamic>> get accountSortFields => [
        {
          "title": TextRoutes.code,
          "value": "id",
          "icon": Icons.numbers,
        },
        {
          "title": TextRoutes.customerName,
          "value": "name",
          "icon": Icons.person,
        },
        {
          "title": TextRoutes.eMail,
          "value": "email",
          "icon": Icons.email,
        },
        {
          "title": TextRoutes.phoneNumber,
          "value": "phone",
          "icon": Icons.phone,
        },
        {
          "title": TextRoutes.address,
          "value": "address",
          "icon": Icons.gps_fixed,
        },
        {
          "title": TextRoutes.createDate,
          "value": "date",
          "icon": Icons.calendar_today,
        },
      ];
  //! --------------------------------------------------------
  //? Class to connect with database:
  ClientsData clientsData = ClientsData();
  //? Status Request:
  StatusRequest statusRequest = StatusRequest.none;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  UsersClass usersClass = UsersClass();

  AccountClass accountClass = AccountClass();
//?

  void clearSupplierFields() {
    supplierNameController.clear();
    supplierPhone1Controller.clear();
    supplierPhone2Controller.clear();
    supplierAddressController.clear();
    supplierEmailController.clear();
    supplierNoteController.clear();
  }

  void clearCustomerFields() {
    customerNameController.clear();
    customerPhone1Controller.clear();
    customerPhone2Controller.clear();
    customerAddressController.clear();
    customerEmailController.clear();
    customerNoteController.clear();
  }

  void clearSearchFields() {
    fromDateController.clear();
    fromNoController.clear();
    toDateController.clear();
    toNoController.clear();
    addressController.clear();
    nameController.clear();
    phoneController.clear();
    onSearchData(true)();
  }

  final CustomShowPopupMenu customShowPopupMenu = CustomShowPopupMenu();
  //? Search Controller:
  TextEditingController fromNoController = TextEditingController();
  TextEditingController toNoController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  /// ---------- Customer Controllers ----------
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhone1Controller =
      TextEditingController();
  final TextEditingController customerPhone2Controller =
      TextEditingController();
  final TextEditingController customerAddressController =
      TextEditingController();
  final TextEditingController customerEmailController = TextEditingController();
  final TextEditingController customerNoteController = TextEditingController();
  int? customerId;

  /// ---------- Supplier Controllers ----------
  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController supplierPhone1Controller =
      TextEditingController();
  final TextEditingController supplierPhone2Controller =
      TextEditingController();
  final TextEditingController supplierAddressController =
      TextEditingController();
  final TextEditingController supplierEmailController = TextEditingController();
  final TextEditingController supplierNoteController = TextEditingController();
  int? supplierId;
  List<Map<String, dynamic>> get addCustomerFields => [
        {
          "title": TextRoutes.customerName,
          "icon": Icons.person,
          "controller": customerNameController,
          "valid": "",
          'required': true
        },
        {
          "title": TextRoutes.phoneNumber,
          "icon": Icons.phone,
          "controller": customerPhone1Controller,
          "valid": "",
          'required': true
        },
        {
          "title": TextRoutes.phoneNumber2,
          "icon": Icons.phone,
          "controller": customerPhone2Controller,
          "valid": "",
          'required': false
        },
        {
          "title": TextRoutes.address,
          "icon": Icons.location_pin,
          "controller": customerAddressController,
          "valid": "",
          'required': false
        },
        {
          "title": TextRoutes.eMail,
          "icon": Icons.email,
          "controller": customerEmailController,
          "valid": "email",
          'required': false
        },
        {
          "title": TextRoutes.note,
          "icon": Icons.note,
          "controller": customerNoteController,
          "valid": "",
          'required': false
        },
      ];
  List<Map<String, dynamic>> get addSupplierFields => [
        {
          "title": TextRoutes.supplierName,
          "icon": Icons.store,
          "controller": supplierNameController,
          "valid": "",
          'required': true
        },
        {
          "title": TextRoutes.phoneNumber,
          "icon": Icons.phone,
          "controller": supplierPhone1Controller,
          "valid": "",
          'required': true
        },
        {
          "title": TextRoutes.phoneNumber2,
          "icon": Icons.phone,
          "controller": supplierPhone2Controller,
          "valid": "",
          'required': false
        },
        {
          "title": TextRoutes.address,
          "icon": Icons.location_pin,
          "controller": supplierAddressController,
          "valid": "",
          'required': false
        },
        {
          "title": TextRoutes.eMail,
          "icon": Icons.email,
          "controller": supplierEmailController,
          "valid": "email",
          'required': false
        },
        {
          "title": TextRoutes.note,
          "icon": Icons.note,
          "controller": supplierNoteController,
          "valid": "",
          'required': false
        },
      ];
  //! --------------------------------------------------------
  //? Link each function with fetched table:
  Future<void> Function() onSearchData(bool showRefresh) {
    switch (selectedSection) {
      case TextRoutes.customers:
        return () => fetchCustomersData(isRefresh: showRefresh);
      case TextRoutes.suppliers:
        return () => fetchSuppliersData(isRefresh: showRefresh);

      default:
        return () => fetchCustomersData(isRefresh: showRefresh);
    }
  }

//! --------------------------------------------------------
  //? Fetch General Ledger:
  Future<void> fetchCustomersData({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();
    String? name =
        nameController.text.trim().isEmpty ? null : nameController.text.trim();
    String? address = addressController.text.trim().isEmpty
        ? null
        : addressController.text.trim();
    String? phone = phoneController.text.trim().isEmpty
        ? null
        : phoneController.text.trim();

    await fetchClientData<UsersModel>(
      isRefresh: isRefresh,
      targetList: customersData,
      fromJson: (e) => UsersModel.fromJson(e),
      apiCall: () async => clientsData.getCustomersData(
        customerAddress: address,
        customerName: name,
        customerPhone: phone,
        sortBy: selectedSortField,
        isAsc: sortAscending,
        limit: itemsPerPage,
        offset: itemsOffset,
        startNo: startNo,
        endNo: endNo,
        startTime: startDate,
        endTime: endDate,
      ),
    );
  }

  //? Fetch Supplier:
  Future<void> fetchSuppliersData({bool isRefresh = false}) async {
    String? startNo = fromNoController.text.trim().isEmpty
        ? null
        : fromNoController.text.trim();
    String? endNo =
        toNoController.text.trim().isEmpty ? null : toNoController.text.trim();
    String? startDate = fromDateController.text.trim().isEmpty
        ? null
        : fromDateController.text.trim();
    String? endDate = toDateController.text.trim().isEmpty
        ? null
        : toDateController.text.trim();
    String? name =
        nameController.text.trim().isEmpty ? null : nameController.text.trim();
    String? address = addressController.text.trim().isEmpty
        ? null
        : addressController.text.trim();
    String? phone = phoneController.text.trim().isEmpty
        ? null
        : phoneController.text.trim();

    await fetchClientData<UsersModel>(
      isRefresh: isRefresh,
      targetList: customersData,
      fromJson: (e) => UsersModel.fromJson(e),
      apiCall: () async => clientsData.getSuppliersData(
        customerAddress: address,
        customerName: name,
        customerPhone: phone,
        sortBy: selectedSortField,
        isAsc: sortAscending,
        limit: itemsPerPage,
        offset: itemsOffset,
        startNo: startNo,
        endNo: endNo,
        startTime: startDate,
        endTime: endDate,
      ),
    );
  }

  String selectedSection = TextRoutes.customers;
  //? Check Then Add Account
  changeAccountSection(String value) {
    selectedSection = value;
    onSearchData(true)();
    update();
  }

  //? Add Customer:
  addCustomerData(BuildContext context) async {
    try {
      if (formState.currentState!.validate()) {
        Map<String, dynamic> accountData = {
          "account_name": customerNameController.text,
          "account_type": TextRoutes.assets,
          "account_parent_id": 9,
          "account_created_at": currentTime,
        };

        int accountId = await accountClass.addAccount(accountData);

        if (accountId > 0) {
          Map<String, dynamic> data = {
            "users_name": customerNameController.text,
            "users_email": customerEmailController.text,
            "users_phone": customerPhone1Controller.text,
            "users_phone2": customerPhone2Controller.text,
            "users_note": customerNoteController.text,
            "users_address": customerAddressController.text,
            "users_createdate": currentTime,
            "account_id": accountId,
          };

          int response = await usersClass.addUser(data);

          if (response > 0) {
            showSuccessSnackBar(TextRoutes.dataAddedSuccess);
            Navigator.pop(context);
            onSearchData(true)();
            clearCustomerFields();
          }
        } else {
          showErrorSnackBar(TextRoutes.failAddData);
        }
      }
    } catch (e) {
      showErrorDialog(
        e.toString(),
        message: TextRoutes.failAddData,
      );
    } finally {
      update();
    }
  }

  //? Add Customer:
  editCustomerData(BuildContext context) async {
    try {
      if (formState.currentState!.validate()) {
        Map<String, dynamic> data = {
          "users_name": customerNameController.text,
          "users_email": customerEmailController.text,
          "users_phone": customerPhone1Controller.text,
          "users_phone2": customerPhone2Controller.text,
          "users_note": customerNoteController.text,
          "users_address": customerAddressController.text,
        };

        int response = await clientsData.editCustomer(data, customerId!);

        if (response > 0) {
          showSuccessSnackBar(TextRoutes.dataUpdatedSuccess);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          onSearchData(true)();
          clearCustomerFields();
        } else {
          showErrorSnackBar(TextRoutes.dataUpdatedSuccess);
        }
      }
    } catch (e) {
      showErrorDialog(
        e.toString(),
        message: TextRoutes.failUpdateData,
      );
    } finally {
      update();
    }
  }

  //? Edit Supplier:
  editSupplierData(BuildContext context) async {
    try {
      if (formState.currentState!.validate()) {
        Map<String, dynamic> data = {
          "supplier_name": supplierNameController.text,
          "supplier_email": supplierEmailController.text,
          "supplier_phone": supplierPhone1Controller.text,
          "supplier_phone2": supplierPhone2Controller.text,
          "supplier_note": supplierNoteController.text,
          "supplier_address": supplierAddressController.text,
        };

        int response = await clientsData.editSupplier(data, supplierId!);

        if (response > 0) {
          showSuccessSnackBar(TextRoutes.dataUpdatedSuccess);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          onSearchData(true)();
          clearCustomerFields();
        } else {
          showErrorSnackBar(TextRoutes.failAddData);
        }
      }
    } catch (e) {
      showErrorDialog(
        e.toString(),
        message: TextRoutes.failUpdateData,
      );
    } finally {
      update();
    }
  }

  //? Add Supplier
  addSupplierData(BuildContext context) async {
    try {
      if (formState.currentState!.validate()) {
        Map<String, dynamic> accountData = {
          "account_name": supplierNameController.text,
          "account_type": TextRoutes.liabilities,
          "account_parent_id": 20,
          "account_created_at": currentTime,
        };

        int accountId = await accountClass.addAccount(accountData);

        if (accountId > 0) {
          Map<String, dynamic> data = {
            "supplier_name": supplierNameController.text,
            "supplier_email": supplierEmailController.text,
            "supplier_phone": supplierPhone1Controller.text,
            "supplier_phone2": supplierPhone2Controller.text,
            "supplier_note": supplierNoteController.text,
            "supplier_address": supplierAddressController.text,
            "supplier_create_date": currentTime,
            "account_id": accountId,
          };

          int response = await clientsData.addSupplier(data);

          if (response > 0) {
            Navigator.pop(context);
            showSuccessSnackBar(TextRoutes.dataAddedSuccess);
            clearSupplierFields();
            onSearchData(true)();
          }
        } else {
          showErrorSnackBar(TextRoutes.failAddData);
        }
      }
    } catch (e) {
      showErrorDialog(
        e.toString(),
        message: TextRoutes.failAddData,
      );
    } finally {
      update();
    }
  }

  //! --------------------------------------------------------
//? General Fetch Reports Function
  Future<void> fetchClientData<T>({
    required Future<Map<String, dynamic>> Function() apiCall,
    required List<T> targetList,
    required T Function(Map<String, dynamic>) fromJson,
    required bool isRefresh,
  }) async {
    try {
      if (isRefresh) {
        statusRequest = StatusRequest.loading;
        update();
        itemsOffset = 0;
        targetList.clear();
      }

      final response = await apiCall();
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        final dataMap = response['data'];
        if (dataMap.isNotEmpty) {
          targetList.addAll(dataMap.map<T>((e) => fromJson(e)).toList());
          itemsOffset += itemsPerPage;
        } else {
          if (isRefresh || targetList.isEmpty) {
            statusRequest = StatusRequest.noData;
          }
          showSuccessSnackBar(TextRoutes.allDataLoaded);
        }
      } else {
        showErrorSnackBar(TextRoutes.failDuringFetchData);
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      statusRequest = StatusRequest.serverException;
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    onSearchData(true)();
    super.onInit();
  }
}
