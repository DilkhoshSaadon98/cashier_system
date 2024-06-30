import 'package:cashier_system/core/constant/routes.dart';
import 'package:cashier_system/core/middleware/mymiddleware.dart';
import 'package:cashier_system/view/Settings/change_userName_password.dart';
import 'package:cashier_system/view/Settings/setting_screen.dart';
import 'package:cashier_system/view/Settings/tabs/backup_screen.dart';
import 'package:cashier_system/view/Settings/tabs/customers_details.dart';
import 'package:cashier_system/view/Settings/tabs/system_update_screen.dart';
import 'package:cashier_system/view/auth/login/login_screen.dart';
import 'package:cashier_system/view/auth/signup/signup_screen.dart';
import 'package:cashier_system/view/auth/system_auth/register_system_screen.dart';
import 'package:cashier_system/view/buying/buying_screen.dart';
import 'package:cashier_system/view/buying/view_details/view_buying_details_screen.dart';
import 'package:cashier_system/view/cashier/cashier_screen.dart';
import 'package:cashier_system/view/categories/catagories_screen.dart';
import 'package:cashier_system/view/categories/components/edit_categories_screen.dart';
import 'package:cashier_system/view/categories/components/add_categories_screen.dart';
import 'package:cashier_system/view/home/drawer/acount_screen.dart';
import 'package:cashier_system/view/home/drawer/add_admin_screen.dart';
import 'package:cashier_system/view/home/home_screen.dart';
import 'package:cashier_system/view/import_export/desktop/export/export_screen.dart';
import 'package:cashier_system/view/import_export/desktop/import/import_screen.dart';
import 'package:cashier_system/view/import_export/import_export_screen.dart';
import 'package:cashier_system/view/import_export/mobile/export/export_screen_mobile.dart';
import 'package:cashier_system/view/import_export/mobile/import/import_screen_mobile.dart';
import 'package:cashier_system/view/inventory/components/creditor/view_creditor_details.dart';
import 'package:cashier_system/view/inventory/components/edit_import_export.dart';
import 'package:cashier_system/view/inventory/inventory_screen.dart';
import 'package:cashier_system/view/items/components/items_add_screen.dart';
import 'package:cashier_system/view/items/components/items_update_screen.dart';
import 'package:cashier_system/view/items/items_screen.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  //! Start Root :
  GetPage(
      name: "/",
      page: () => const LoginScreen(),
      middlewares: [MyMiddleWare()]),
  //! Auth:
  GetPage(name: AppRoute.loginScreen, page: () => const LoginScreen()),
  GetPage(name: AppRoute.signupScreen, page: () => const SignupScreen()),
  GetPage(
      name: AppRoute.registerSystemScreen,
      page: () => const RegisterSystemScreen()),
  //!  Home Roots :
  GetPage(name: AppRoute.homeScreen, page: () => const HomeScreen()),
  GetPage(name: AppRoute.buingScreen, page: () => const BuyingScreen()),
  GetPage(name: AppRoute.settingScreen, page: () => const SettingScreen()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.cashierScreen,
      page: () => const CashierScreen()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.catagoriesScreen,
      page: () => const CatagoriesScreen()),
  GetPage(name: AppRoute.inventoryScreen, page: () => const InventoryScreen()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.importExportScreen,
      page: () => const ImportExportScreen()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.itemsScreen,
      page: () => const ItemsScreen()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.accountScreen,
      page: () => const AcountScreen()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.addAdminScreen,
      page: () => const AddAdminScreen()),
  //! Settings Routes
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.updateScreen,
      page: () => const UpdateSystemScreen()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.backUpScreen,
      page: () => const BackupScreen()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.changeUsernamePassword,
      page: () => const ChangeUsernamePassword()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.customerDetailsScreen,
      page: () => const CustomersDetails()),
  //!Categories Routes:
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.categoriesUpdateScreen,
      page: () => const EditCatagories()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.categoriesAddScreen,
      page: () => const AddCategoriesScreen()),
  //!Items Routes:
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.categoriesUpdateScreen,
      page: () => const EditCatagories()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.itemsAddScreen,
      page: () => const ItemsAddScreen()),
  GetPage(
      transitionDuration: const Duration(milliseconds: 200),
      name: AppRoute.itemsUpdateScreen,
      page: () => const ItemsUpdateScreen()),
  //! Import Export
  GetPage(
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      name: AppRoute.importScreen,
      page: () => const ImportScreen()),
  GetPage(
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      name: AppRoute.exportScreen,
      page: () => const ExportScreen()),
  GetPage(
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      name: AppRoute.exportScreenMobile,
      page: () => const ExportScreenMobile()),
  GetPage(
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      name: AppRoute.importScreenMobile,
      page: () => const ImportScreenMobile()),
  //! Inventorty:
  GetPage(
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      name: AppRoute.editImportExport,
      page: () => const EditImportExportScreen()),
  GetPage(
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      name: AppRoute.viewCreditorScreen,
      page: () => const ViewCreditorDetails()),
  //! Buying :
  GetPage(
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      name: AppRoute.buyingDetailsScreen,
      page: () => const ViewBuyingDetailsScreen()),
];
