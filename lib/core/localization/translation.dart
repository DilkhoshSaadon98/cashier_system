import 'package:get/get.dart';

class MyTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "ar": {
          "IQD": "د.ع",
          //! Home Translate
          "Cashier": "الكاشير",
          "Imp/Exp": "صادرات والواردات",
          "Inventory": "المخزون",
          "Buying": "المشتريات",
          "Catagories": "الأصناف",
          "Items": "المواد",
          "Settings": "الاعدادات",
          "Add Admin": "أضافة مسئول",
          "About us": "معلومات حولنا",
          "Logout": "تسجيل خروج",
          //! Cashier Translate
          "Total Price": "السعر الأجمالي",
          "PAY": "الدفع",
          "New Bill": "حساب جديد",
          "Delay": "تصغير",
          "Print": "طباعة",
          "Order Discount": "خصم الطلب",
          "Item Discount": "خصم المادة",
          "Gift": "هدية",
          "QTY": "عدد",
          "Delete Cart": "حذف الطلب",
          "Delete Item": "حذف المادة",
          "Tax": "ضرائب",
          "Customer Name": "اسم الزبون",
          "Cashback / Cash": "ترجيع",
          "Cash Payment": "دفع نقدي",
          "Dept Payment": "دفع بالدين",
          "Edit Previous": "تعديل أخر طلب",
          "Export PDF": "تصدير",
          "Quantity": "العدد",
          "Stack": "المخزون",
          "Discount Price": "سعر الخصم",
          "Price": "السعر",
          "Type": "النوع",
          "Items Name": "اسم المادة",
          "Code": "الكود",
          "Invoice Orgnaizer": "منظم الطلب",
          "Item Numbers": "عدد المواد",
          "Discount": "الخصم",
          "Add New Customer": "أضافة زبون جديد",
          "Add New Account?": "أضافة حساب جديد؟",
          "Search for Customer Name": "بحث عن اسم الزبون",
          "Full Name": "الأسم الثلاثي",
          "Phone Number": "رقم الهاتف",
          "Address": "العنوان",
          "Order Payment": "الدفع",
          " ": "المبلغ المدفوع",
          "Remender": "الباقي",
          "Last Invoices": "الطلبات السابقة",
          "Please choose items or scanning a barcode":
              "الرجاء أختيار العناصر أو مسح الباركود",
          //!Import Export Translate:
          "Imports": "واردات",
          "Exports": "صادرات",
          "Search": "بحث",
          "Add": "أضافة",
          "Supplier Name": "اسم المورد",
          "Date": "التاريخ",
          "Ballance": "الرصيد",
          "Amount ": "المبلغ",
          "Box": "الصندوق",
          "Employee": "الموظفين",
          "Import Money": "أستيراد الأموال",
          //! Inventory Translate:
          "Bills": "المبيعات",
          "All": "عرض الكل",
          "Invoice Date": "تاريخ الفاتورة",
          "Invoice Amount": "مبلغ الفاتورة",
          "Invoice Type": "نوع الفاتورة",
          "Total Ballance": "المبلغ الكلي",
          "Total Bills Ballance": "مبلغ المبيعات",
          "Total Imports Ballance": "مبلغ الواردات",
          "Total Exports Ballance": "مبلغ الصادرات",
          "Invoice Payment": "وسيلة الدفع",
          "Total Invoice Price": "مبلغ الفاتورة",
          "Invoice Cost": "مصاريف الفاتورة",
          'Invoice Profit': "أرباح الفاتورة",
          "Import Number": "رقم الوارد",
          "Import Account": "حساب الوارد",
          "Import Price": "مبلغ الوارد",
          "Import Note": "ملاحظات",
          "Import Date": "تاريخ الوارد",
          "Export Number": "رقم الصادر",
          "Export Price": "مبلغ الصادر",
          "Export Account": "حساب الصادر",
          "Export Note": "ملاحظات",
          "Export Date": "تاريخ الصادر",
          "Profits": "الأرباح",
          "Expense Number": "رقم المصرف",
          "Expense Title": "عنوان المصرف",
          "Expense Price": "مبلغ المصروف",
          'Expense Note': "ملاحظات",
          "Expense Date": "تاريخ الصرف",
          //! Items Translate
          "View Items": "عرض العناصر",
          "Add Items": "أضافة عنصر",
          "Search By": "بحث حسب",
          "Items NO": "رقم المادة",
          "Items QTY": "عدد المواد",
          "Items Count": "عدد المواد",
          "Items Type": "نوع المادة",
          "Items Categories": "صنف المادة",
          "Items Explain": "وصف المادة",
          "Categories": "الصنف",
          "Cost Price": "مصاريف المادة",
          "Buying Price": "سعر الشراء",
          "Selling Price": "سعر البيع",
          "Wholesale Price": "سعر بالجملة",
          "Choose Categories": "أختر الصنف",
          "Choose Type": "أختر النوع",
          "Edit Item": "تعديل المادة",
          "Barcode": "باركود",
          "NO": "رقم",
          "Items Types *": "نوع المادة *",
          //! Categories Tranlate:
          "View Categories": "عرض الأصناف",
          "Add Categories": "أضافة صنف",
          "Categories Name": "اسم الصنف",
          "Categories Image": "صورة الصنف",
          "Edit Categories": "تعديل الصنف",
          //! Setting Tranlate:
          "Security": "الحماية",
          "Back Up": "النسخ الأحتياطي",
          "System Update": "تحديثات النظام",
          "Invoice": "الفواتير",
          "Customers Details": "معلومات الزبائن",
          "System Language": "لغة النظام",
          //*Secutity:
          "Change Username and Password": "تغيير اسم المستخدم وكلمة المرور",
          "Old Username": "اسم المستخدم القديم",
          "Old Password": "كلمة المرور القديمة",
          "New Username": "اسم مستخدم جديد",
          "New Password": "كلمة المرور الجديدة",
          "Request manager password for": "طلب كلمة مرور المدير لـ",
          "Show Data": "إظهار البيانات",
          "Login": "تسجيل الدخول",
          "Save Changes":"حفظ التغييرات",
          //! Shareed Text:
          "Select": "تحديد",
          "Account": "الحساب",
          "Invoice Number": "رقم الطلب",
          "From": "من",
          "To": "الى",
          "Note": "ملاحظة",
          "Expenses": "المصاريف",

          //! Dilog Box
          "Please select one row at least": "الرجاء أختيار عنصر واحد على الأقل",
          "Please Finish Previous Card to start new one":
              "الرجاء انهاء الطلبات السابقة لبدء طلب جديد"
        }
      };
}
