import 'package:cashier_system/core/constant/screen_routes.dart';
import 'package:cashier_system/core/middleware/mymiddleware.dart';
import 'package:cashier_system/view/add_account/add_account_screen.dart';
import 'package:cashier_system/view/auth/system_auth/verify_account_screen.dart';
import 'package:cashier_system/view/buying/mobile/view_buying_details_screen_mobile.dart';
import 'package:cashier_system/view/categories/categories_add_screen.dart';
import 'package:cashier_system/view/clients/clients_screen.dart';
import 'package:cashier_system/view/invoices/invoices_screen.dart';
import 'package:cashier_system/view/invoices/sale_invoice_screen.dart';
import 'package:cashier_system/view/items/items_screen.dart';
import 'package:cashier_system/view/items/items_view_screen.dart';
import 'package:cashier_system/view/reports/billing_profits/billing_profits_screen.dart';
import 'package:cashier_system/view/reports/daily_reports/daily_reports_screen.dart';
import 'package:cashier_system/view/reports/financial_reports/financial_reports_screen.dart';
import 'package:cashier_system/view/reports/inventory_reports/inventory_reports_screen.dart';
import 'package:cashier_system/view/reports/reports_screen.dart';
import 'package:cashier_system/view/settings/setting_screen.dart';
import 'package:cashier_system/view/settings/windows/tabs/backup_screen_windows.dart';
import 'package:cashier_system/view/settings/windows/tabs/system_update_screen_windows.dart';
import 'package:cashier_system/view/auth/login/login_screen.dart';
import 'package:cashier_system/view/auth/system_auth/register_system_screen.dart';
import 'package:cashier_system/view/buying/buying_screen.dart';
import 'package:cashier_system/view/buying/windows/view_details/view_buying_details_screen.dart';
import 'package:cashier_system/view/cashier/cashier_screen.dart';
import 'package:cashier_system/view/categories/catagories_screen.dart';
import 'package:cashier_system/view/home/drawer/acount_screen.dart';
import 'package:cashier_system/view/home/drawer/add_admin_screen.dart';
import 'package:cashier_system/view/home/home_screen.dart';
import 'package:cashier_system/view/transactions/journal_voucher_screen.dart';
import 'package:cashier_system/view/transactions/opening_entry_screen.dart';
import 'package:cashier_system/view/transactions/transaction_receipt_screen.dart';
import 'package:cashier_system/view/transactions/transactions_payment_screen.dart';
import 'package:cashier_system/view/transactions/transactions_screen.dart';
import 'package:cashier_system/view/units/units_screen.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  //! Start Root :
  GetPage(
      name: "/",
      page: () => const LoginScreen(),
      middlewares: [MyMiddleWare()]),
  //! Auth:
  GetPage(name: AppRoute.loginScreen, page: () => const LoginScreen()),
  GetPage(
      name: AppRoute.registerSystemScreen,
      page: () => const RegisterSystemScreen()),
  GetPage(
      name: AppRoute.verifyAccountScreen,
      page: () => const VerifyAccountScreen()),
  //!  Home Roots :
  GetPage(name: AppRoute.clientScreen, page: () => const ClientsScreen()),
  GetPage(name: AppRoute.homeScreen, page: () => const HomeScreen()),
  GetPage(name: AppRoute.buyingScreen, page: () => const BuyingScreen()),
  GetPage(name: AppRoute.settingScreen, page: () => const SettingScreen()),
  GetPage(name: AppRoute.cashierScreen, page: () => CashierScreen()),
  GetPage(
      name: AppRoute.catagoriesScreen, page: () => const CatagoriesScreen()),
  GetPage(name: AppRoute.itemsScreen, page: () => const ItemsScreen()),
  GetPage(name: AppRoute.accountScreen, page: () => const AcountScreen()),
  GetPage(name: AppRoute.addAdminScreen, page: () => const AddAdminScreen()),
  GetPage(
      name: AppRoute.addAccountScreen, page: () => const AddAccountScreen()),
  //! Settings Routes
  GetPage(name: AppRoute.updateScreen, page: () => const UpdateSystemScreen()),
  GetPage(name: AppRoute.backUpScreen, page: () => const BackupScreen()),
  GetPage(name: AppRoute.invoiceScreen, page: () => const InvoicesScreen()),
  //!Categories Routes:
  GetPage(
      name: AppRoute.categoriesAddScreen,
      page: () => const CategoriesAddScreen()),

  //!Items Routes:

  GetPage(name: AppRoute.unitsScreen, page: () => const UnitsScreen()),
  GetPage(name: AppRoute.itemsViewScreen, page: () => const ItemsViewScreen()),

  //! Reports Screen:

  GetPage(name: AppRoute.reportsScreen, page: () => const ReportsScreen()),
  GetPage(
      name: AppRoute.dailyReportsScreen,
      page: () => const DailyReportsScreen()),
  GetPage(
      name: AppRoute.inventoryReportsScreen,
      page: () => const InventoryReportsScreen()),
  GetPage(
      name: AppRoute.billingProfitsScreen,
      page: () => const BillingProfitsScreen()),
  GetPage(
      name: AppRoute.financialReportsScreen,
      page: () => const FinancialReportsScreen()),
  //! Transaction Screen:

  GetPage(
      name: AppRoute.transactionScreen, page: () => const TransactionsScreen()),
  GetPage(
      name: AppRoute.transactionPaymentScreen,
      page: () => const TransactionsPaymentScreen()),
  GetPage(
      name: AppRoute.transactionReceiptScreen,
      page: () => const TransactionReceiptScreen()),
  GetPage(
      name: AppRoute.journalVoucherScreen,
      page: () => const JournalVoucherScreen()),
  GetPage(
      name: AppRoute.openingEntryScreen,
      page: () => const OpeningEntryScreen()),

  //! Buying :
  GetPage(
      name: AppRoute.buyingDetailsScreen,
      page: () => const ViewBuyingDetailsScreen()),
  GetPage(
      name: AppRoute.buyingDetailsScreenMobile,
      page: () => const ViewBuyingDetailsScreenMobile()),
  //! Invoices:
  GetPage(
      name: AppRoute.saleInvoiceScreen, page: () => const SaleInvoiceScreen()),
];
