1- Categories Table
 CREATE TABLE "tbl_types" (
    "type_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "type_name" TEXT NOT NULL,
    "categories_createdate" INTEGER NOT NULL
    )
----------------------------------------------    
2- Types Table
 CREATE TABLE "tbl_types" (
    "type_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "type_name" TEXT NOT NULL,
    "type_createdate" TEXT NOT NULL
    )
----------------------------------------------
3- Table Items
    CREATE TABLE "tbl_items" (
    "items_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "items_name" TEXT NOT NULL,
    "items_barcode" TEXT NOT NULL,
    "items_selling" int NOT NULL,
    "items_buingprice" int NOT NULL,
    "items_wholesaleprice" int NOT NULL,
    "items_count" int NOT NULL,
    "items_costprice" int NOT NULL,
    "items_desc" TEXT NOT NULL,
    "items_createdate" TEXT NOT NULL,
    "items_cat" INTEGER NOT NULL,
    "items_type" INTEGER NOT NULL,
    FOREIGN KEY (items_type) REFERENCES tbl_types (type_id) FOREIGN KEY (items_cat) REFERENCES tbl_categories (categories_id)
    )
------------------------------------------
4-Table Users
    CREATE TABLE "tbl_users" (
    users_id INTEGER PRIMARY KEY AUTOINCREMENT,
    "users_name" TEXT NOT NULL,
    "users_email" TEXT,
    "users_phone2" Text,
    "users_phone" TEXT NOT NULL,
    "users_address" TEXT NOT NULL,
    "users_role" TEXT NOT NULL,
    "users_createdate" TEXT NOT NULL
    )
    ------------------------------------
5- Table Cart
        CREATE TABLE "tbl_cart" (
            "cart_id" INTEGER PRIMARY KEY AUTOINCREMENT,
            "cart_items_id" INTEGER NOT NULL,
            "cart_orders" INTEGER NOT NULL DEFAULT 0,
            "cart_number" INTEGER NOT NULL DEFAULT 0,
            "cart_item_discount" INTEGER NOT NULL DEFAULT 0,
            "cart_discount" INTEGER NOT NULL DEFAULT 0,
            "cart_item_gift" INTEGER NOT NULL DEFAULT 0,
            "cart_owner" TEXT DEFAULT UNKNOWN,
            "cart_items_count" INTEGER NOT NULL,
            "cart_create_date" TEXT NOT NULL,
            "cart_status" TEXT NOT NULL DEFAULT 'review',
            "cart_tax" TEXT DEFAULT '0', 
            "cart_cash" TEXT DEFAULT '1',
            FOREIGN KEY (cart_items_id) REFERENCES tbl_items(items_id)
          )
------------------------------------------------
6-Table Invoice
    CREATE TABLE "tbl_invoice" (
          "invoice_id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "invoice_user_id" INTEGER NOT NULL,
          "invoice_tax" INTEGER NOT NULL,
          "invoice_discount" INTEGER NOT NULL,
          "invoice_price" INTEGER NOT NULL,
          "invoice_cost" INTEGER NOT NULL,
          "invoice_items_number" INTEGER NOT NULL,
          "invoice_payment" TEXT NOT NULL,
          "invoice_createdate" TEXT NOT NULL,
          FOREIGN KEY (invoice_user_id) REFERENCES tbl_users (users_id)
           )
------------------------------------------------
7-Table Import
          CREATE TABLE "tbl_import" (
          "import_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          "import_supplier_id" INTEGER NOT NULL,
          "import_amount" INTEGER NOT NULL,
          "import_account" TEXT NOT NULL,
          "import_note" TEXT NOT NULL,
          "import_create_date" TEXT NOT NULL
          )
7-Table Export
        CREATE TABLE "tbl_export" (
            "export_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            "export_supplier_id" INTEGER NOT NULL,
            "export_amount" INTEGER NOT NULL,
            "export_account" TEXT NOT NULL,
            "export_note" TEXT NOT NULL,
            "export_create_date" TEXT NOT NULL
        )
==========================================================
==========================================================
==========================================================
View
1 - Cart View
 CREATE VIEW cartview AS
      SELECT SUM(
              CAST(
                  tbl_items.items_selling - tbl_items.items_selling * tbl_cart.cart_item_discount / 100 AS INT
              )
          ) AS items_price_discount, tbl_cart.*, tbl_items.*
      FROM tbl_cart
          INNER JOIN tbl_items ON tbl_items.items_id = tbl_cart.cart_items_id
      WHERE
          cart_orders = 0
      GROUP BY
          tbl_cart.cart_items_id,
          tbl_cart.cart_number,
          tbl_cart.cart_orders
-------------------------------------------------
2- Export View
    CREATE VIEW "exportDetailsView" AS
    SELECT tbl_users.*, tbl_export.*
    FROM tbl_users
        JOIN tbl_export ON tbl_users.users_id = tbl_export.export_supplier_id
-------------------------------------------------
3- Import View
    CREATE VIEW importDetailsView AS
    SELECT tbl_users.*, tbl_import.*
    FROM tbl_users
        JOIN tbl_import ON tbl_users.users_id = tbl_import.import_supplier_id
-------------------------------------------------
4 - Item View:
CREATE VIEW itemsView AS
SELECT tbl_items.*, tbl_categories.categories_name, tbl_types.type_name
FROM
    tbl_items
    INNER JOIN tbl_categories ON tbl_items.items_cat = tbl_categories.categories_id
    INNER JOIN tbl_types ON tbl_items.items_type = tbl_types.type_id
GROUP BY
    tbl_items.items_id,
    tbl_categories.categories_id,
    tbl_types.type_id
-------------------------------------------------
4 - Total Profit View:
CREATE VIEW totalProfitView AS
WITH CombinedInvoices AS (
    SELECT
        'Cash' AS invoice_source_table,
        tbl_invoice.invoice_price AS invoice_price,
        tbl_invoice.invoice_createdate AS invoice_createdate
    FROM tbl_invoice
    WHERE tbl_invoice.invoice_payment = 'Cash'
    UNION ALL
    SELECT
        'Export' AS invoice_source_table,
        tbl_export.export_amount AS invoice_price,
        tbl_export.export_create_date AS invoice_createdate
    FROM tbl_export
    WHERE tbl_export.export_account = 'Expenses'
)
SELECT
    invoice_source_table,
    invoice_price,
    invoice_createdate,
    ROW_NUMBER() OVER (ORDER BY invoice_createdate) AS invoice_id
FROM CombinedInvoices;

-------------------------------------------------
4 - Box View:
CREATE VIEW boxView AS
WITH
    CombinedInvoices AS (
        SELECT
            'Cash' AS invoice_source_table,
            tbl_invoice.invoice_price AS invoice_price,
            tbl_invoice.invoice_createdate AS invoice_createdate
        FROM tbl_invoice
        WHERE
            tbl_invoice.invoice_payment = 'Cash'
        UNION ALL
        SELECT
            'Import' AS invoice_source_table,
            tbl_import.import_amount AS invoice_price,
            tbl_import.import_create_date AS invoice_createdate
        FROM tbl_import
        UNION ALL
        SELECT
            'Export' AS invoice_source_table,
            tbl_export.export_amount AS invoice_price,
            tbl_export.export_create_date AS invoice_createdate
        FROM tbl_export
    )
SELECT
    invoice_source_table,
    invoice_price,
    invoice_createdate,
    ROW_NUMBER() OVER (
        ORDER BY invoice_createdate
    ) AS 'invoice_id'
FROM CombinedInvoices
-------------------------------------------------
4 - Invoice View:
CREATE VIEW invoiceView AS
SELECT tbl_invoice.*
FROM tbl_invoice
    LEFT JOIN tbl_users ON tbl_invoice.invoice_user_id = tbl_users.users_id
-------------------------------------------------

CREATE VIEW debtorView AS
SELECT
    u.users_id AS id,
    u.users_name,
    COALESCE(
        COUNT(
            DISTINCT CASE
                WHEN i.invoice_payment = 'Dept' THEN i.invoice_id
            END
        ),
        0
    ) AS total_invoices_count,
    COALESCE(
        COUNT(
            DISTINCT CASE
                WHEN e.export_account = 'Employee' THEN e.export_id
            END
        ),
        0
    ) AS total_exports_count,
    COALESCE(
        COUNT(DISTINCT im.import_id),
        0
    ) AS total_imports_count,
    COALESCE(
        SUM(
            CASE
                WHEN i.invoice_payment = 'Dept' THEN i.invoice_price
                ELSE 0
            END
        ),
        0
    ) AS total_invoice_value_dept,
    COALESCE(SUM(im.import_amount), 0) AS total_import_value,
    COALESCE(
        SUM(
            CASE
                WHEN e.export_account = 'Employee' THEN e.export_amount
                ELSE 0
            END
        ),
        0
    ) AS total_export_value_employee,
    COALESCE(SUM(im.import_amount), 0) - COALESCE(
        SUM(
            CASE
                WHEN i.invoice_payment = 'Dept' THEN i.invoice_price
                ELSE 0
            END
        ),
        0
    ) + COALESCE(
        SUM(
            CASE
                WHEN e.export_account = 'Employee' THEN e.export_amount
                ELSE 0
            END
        ),
        0
    ) AS total_customer_debtor_price
FROM
    tbl_users u
    LEFT JOIN tbl_invoice i ON u.users_id = i.invoice_user_id
    LEFT JOIN tbl_import im ON u.users_id = im.import_supplier_id
    LEFT JOIN tbl_export e ON u.users_id = e.export_supplier_id
GROUP BY
    u.users_name
HAVING
    COALESCE(SUM(im.import_amount), 0) - COALESCE(
        SUM(
            CASE
                WHEN i.invoice_payment = 'Dept' THEN i.invoice_price
                ELSE 0
            END
        ),
        0
    ) + COALESCE(
        SUM(
            CASE
                WHEN e.export_account = 'Employee' THEN e.export_amount
                ELSE 0
            END
        ),
        0
    ) > 0