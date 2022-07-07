/* Formatted on 7/7/2022 12:02:13 PM (QP5 v5.381) */
--------------------------------------Ledger------------------------------------

SELECT * FROM vatdev.sbpa_fg_item_ledger;

SELECT * FROM vatdev.sbpa_supplier_ledger;

SELECT * FROM vatdev.sbpa_customer_ledger;

--------------------------------------Customer----------------------------------

SELECT * FROM vatdev.sbpa_customers;

--------------------------------------Order-------------------------------------

SELECT * FROM vatdev.sbpa_cust_order_dtl;

SELECT * FROM vatdev.sbpa_cust_order_mst;

--------------------------------------Delivery----------------------------------

SELECT * FROM vatdev.sbpa_cust_prod_delivery_dtl;

SELECT * FROM vatdev.sbpa_cust_prod_delivery_mst;

--------------------------------------Item Return-------------------------------

SELECT * FROM vatdev.sbpa_cust_item_return_dtl;

SELECT * FROM vatdev.sbpa_cust_item_return_mst;

--------------------------------------PO----------------------------------------

SELECT * FROM vatdev.sbpa_po_dtl;

SELECT * FROM vatdev.sbpa_po_mst;

--------------------------------------RI----------------------------------------

SELECT * FROM vatdev.sbpa_ri_dtl;

SELECT * FROM vatdev.sbpa_ri_mst;

--------------------------------------Supplier Return---------------------------

SELECT * FROM vatdev.sbpa_supplier_return_dtl;

SELECT * FROM vatdev.sbpa_supplier_return_mst;

--------------------------------------Storage-----------------------------------

SELECT * FROM vatdev.sbpa_customer_ledger;

SELECT * FROM vatdev.sbpa_cust_prod_del_storage;

SELECT * FROM vatdev.sbpa_supplier_return_storage;

SELECT * FROM vatdev.sbpa_cust_item_return_storage;

SELECT * FROM vatdev.sbpa_ri_storage;