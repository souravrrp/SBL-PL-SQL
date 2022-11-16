/* Formatted on 7/31/2022 3:54:13 PM (QP5 v5.381) */
--------------------------------------Ledger------------------------------------

SELECT * FROM vatdev.sbpa_fg_item_ledger;

SELECT * FROM vatdev.sbpa_supplier_ledger;

SELECT * FROM vatdev.sbpa_customer_ledger;

--------------------------------------Customer----------------------------------

SELECT * FROM ifsapp.sbl_vat_customer;

SELECT * FROM vatdev.sbpa_customers;

--------------------------------------Order-------------------------------------

SELECT * FROM ifsapp.customer_order;

SELECT * FROM vatdev.sbpa_cust_order_mst;

SELECT * FROM vatdev.sbpa_cust_order_dtl;


--------------------------------------Delivery----------------------------------

SELECT * FROM ifsapp.sbl_vat_cust_order_deliv_dtl;

SELECT * FROM vatdev.sbpa_cust_prod_delivery_dtl;

SELECT * FROM vatdev.sbpa_cust_prod_delivery_mst;

--------------------------------------Item -------------------------------------

SELECT *
  FROM sbpa_item_mst sim
 WHERE 1 = 1                                       --AND sim.item_type = '002'
             --AND ITEM_CAT_CODE = 'ACSPT'
             AND ITEM_CODE = 'TRWHTS';

--------------------------------------Item Return-------------------------------

SELECT *
  FROM vatdev.sbpa_cust_item_return_dtl
 WHERE 1 = 1 AND CUST_RETURN_NO = 'CHT-H6772';

SELECT *
  FROM vatdev.sbpa_cust_item_return_mst
 WHERE 1 = 1 AND CUST_RETURN_NO = 'CHT-H6772';

--------------------------------------PO----------------------------------------

SELECT *
  FROM vatdev.sbpa_supplier_mst ssm
 WHERE 1 = 1 AND SUP_NO = 'XLBD- AGSL';

SELECT *
  FROM  
 ifsapp.SBL_VAT_SUPPLIER  ssm
 WHERE 1 = 1 AND SUP_NO = 'XLBD- AGSL';

SELECT *
  FROM ifsapp.purchase_order_line_tab t
 WHERE 1 = 1 AND ORDER_NO = 'A-30274162';

SELECT *
  FROM SBL_VAT_PURCHASE_ORDER
 WHERE 1 = 1 AND PO_NO = 'A-30274162';

SELECT *
  FROM IFSAPP.SBL_VAT_PO_DTL_FG
 WHERE 1 = 1 AND PO_NO = 'A-30274162';


SELECT *
  FROM SBL_VAT_PO_DTL_SPARE
 WHERE 1 = 1 AND PO_NO = 'A-30274162';

SELECT *
  FROM SBL_VAT_PO_DTL_FG
 WHERE 1 = 1 AND PO_NO = 'A-30274162';

SELECT *
  FROM vatdev.sbpa_po_dtl
 WHERE 1 = 1 
 AND PO_NO = 'A-30815376';

SELECT *
  FROM vatdev.sbpa_po_mst
 WHERE 1 = 1 
 AND PO_NO = 'A-30274162';


--------------------------------------RI----------------------------------------

SELECT *
  FROM vatdev.sbpa_ri_dtl
 WHERE 1 = 1 AND PO_NO = '';

SELECT *
  FROM vatdev.sbpa_ri_mst
 WHERE 1 = 1 AND PO_NO = 'L-29609';

SELECT *
  FROM IFSAPP.SBL_VAT_PO_RI_MASTER
 WHERE     1 = 1
       AND PO_NO = 'L-29609'
       AND EXISTS
               (SELECT 1
                  FROM ifsapp.purinv_ship_poline_tab s
                 WHERE s.ORDER_NO = PO_NO);


--------------------------------------Supplier Return---------------------------

SELECT * FROM vatdev.sbpa_supplier_return_dtl;

SELECT * FROM vatdev.sbpa_supplier_return_mst;

--------------------------------------Storage-----------------------------------

SELECT * FROM vatdev.sbpa_cust_prod_del_storage;

SELECT * FROM vatdev.sbpa_supplier_return_storage;

SELECT * FROM vatdev.sbpa_cust_item_return_storage;

SELECT * FROM vatdev.sbpa_ri_storage;