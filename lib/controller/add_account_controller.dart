// ignore_for_file: use_build_context_synchronously

import 'package:cashier_system/core/constant/app_theme.dart';
import 'package:cashier_system/core/dialogs/error_dialogs.dart';
import 'package:cashier_system/core/dialogs/snackbar_helper.dart';
import 'package:cashier_system/core/localization/text_routes.dart';
import 'package:cashier_system/data/model/account_model.dart';
import 'package:cashier_system/data/model/users_model.dart';
import 'package:cashier_system/data/source/account_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAccountController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  AccountClass accountClass = AccountClass();
  String screenSection = TextRoutes.search;
  List<UsersModel> customerData = [];
  List<AccountModel> allAccounts = [];
  List<AccountModel> allAccountsData = [];
  List<AccountModel> treeAccounts = [];
  List<int> selectedCustomers = [];

  //? Account Controller
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountCodeController = TextEditingController();
  final TextEditingController accountNoteController = TextEditingController();
  String? accountId;
  String? accountParentId;
  String? accountTypeStr;

  Future<void> getAccountData() async {
    try {
      var response = await accountClass.getAccountsData();
      if (response['status'] == 'success') {
        parseAccounts(response);
      } else {
        showErrorSnackBar(TextRoutes.failDuringFetchData);
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.anErrorOccurred);
    } finally {
      update();
    }
  }

  Future<void> searchAccountData(String accountParentId) async {
    try {
      var response =
          await accountClass.getAccountsData(accountParentId: accountParentId);
      if (response['status'] == 'success') {
        allAccountsData.clear();
        final List data = response['data'];
        allAccountsData = data.map((e) => AccountModel.fromMap(e)).toList();
      }
    } catch (e) {
      showErrorDialog(e.toString(), message: TextRoutes.failDuringFetchData);
    } finally {
      update();
    }
  }

  //! update Account Data:
  updateAccountData(BuildContext context) async {
    if (!formState.currentState!.validate()) {
      showErrorSnackBar(TextRoutes.formValidationFailed);
      return;
    }
    Map<String, dynamic> accountData = {
      "account_name": accountNameController.text,
      "account_code": accountCodeController.text,
      "account_note": accountNoteController.text,
      "account_updated_at": currentTime,
    };
    var response = await accountClass.updateAccount(accountData, accountId);
    if (response > 0) {
      clearAccountsFields();
      showSuccessSnackBar(TextRoutes.dataUpdatedSuccess);
      Navigator.of(context).pop();
      getAccountData();
    }
  }

  //! Add Account Data:
  addAccountsData(BuildContext context) async {
    if (!formState.currentState!.validate()) {
      showErrorSnackBar(TextRoutes.formValidationFailed);
      return;
    }
    Map<String, dynamic> accountData = {
      "account_name": accountNameController.text,
      "account_type": accountTypeStr,
      "account_code": accountCodeController.text,
      "account_note": accountNoteController.text,
      'account_parent_id': accountParentId,
      "account_created_at": currentTime,
    };
    var response = await accountClass.addAccount(accountData);
    if (response > 0) {
      clearAccountsFields();
      showSuccessSnackBar(TextRoutes.dataAddedSuccess);
      Navigator.of(context).pop();
      getAccountData();
    }
  }

  //! Delete Account Data:
  deleteAccountData(BuildContext context, int accountId) async {
    var response = await accountClass.deleteAccount(accountId);
    if (response['status'] == TextRoutes.success) {
      showSuccessSnackBar(response['message']);
    } else {
      showErrorSnackBar(response['message']);
    }
  }

  void parseAccounts(dynamic response) {
    final List data = response['data'];
    allAccounts = data.map((e) => AccountModel.fromMap(e)).toList();
    allAccountsData = List.from(allAccounts);

    Map<int, AccountModel> accountMap = {
      for (var acc in allAccounts) acc.accountId!: acc
    };

    for (var acc in allAccounts) {
      if (acc.accountParentId == null) {
        treeAccounts.add(acc);
      } else {
        final parent = accountMap[acc.accountParentId!];
        if (parent != null) {
          parent.accountChildren.add(acc);
        }
      }
    }
    treeAccounts =
        allAccounts.where((acc) => acc.accountParentId == null).toList();
  }

  void toggleExpanded(AccountModel account) {
    account.isExpanded = !account.isExpanded;
    update();
  }

  void clearAccountsFields() {
    accountCodeController.clear();
    accountNameController.clear();
    accountNoteController.clear();
    accountParentId = null;
    accountId = '';
    accountTypeStr = '';
  }

  @override
  void onInit() {
    getAccountData();
    super.onInit();
  }
}
