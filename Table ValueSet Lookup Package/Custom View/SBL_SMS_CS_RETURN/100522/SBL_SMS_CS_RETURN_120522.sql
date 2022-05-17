/* Formatted on 5/10/2022 10:58:04 AM (QP5 v5.381) */
CREATE OR REPLACE FORCE VIEW IFSAPP.SBL_SMS_CS_RETURN
(
    RMA_NO,
    SITE,
    ORDER_NO,
    LINE_NO,
    REL_NO,
    RETURN_DATE,
    CUSTOMER_NO,
    CUSTOMER_NAME,
    PHONE_NO,
    DELIVERY_SITE,
    PRODUCT_CODE,
    RETURNED_QUANTITY,
    UNIT_NSP,
    SALES_PRICE,
    VAT,
    SALES_RETURN_AMOUNT
)
AS
    SELECT w.rma_no,
           w.site,
           w.order_no,
           w.line_no,
           w.rel_no,
           w.sales_date
               return_date,
           w.customer_no,
           w.customer_name,
           (SELECT c.VALUE
              FROM ifsapp.supplier_info_comm_method c
             WHERE c.supplier_id = w.customer_no AND c.method_id_db = 'PHONE')
               phone_no,
           w.delivery_site,
           w.product_code,
           w.sales_quantity
               returned_quantity,
           w.unit_nsp,
           w.sales_price,
           w.vat,
           w.rsp
               "SALES_RETURN_AMOUNT"
      FROM (SELECT t.invoice_id,
                   t.item_id,
                   t.c10
                       "SITE",
                   t.c1
                       ORDER_NO,
                   t.c2
                       LINE_NO,
                   t.c3
                       REL_NO,
                   t.n1
                       LINE_ITEM_NO,
                   t.c4
                       ACCT_LINE_NO,
                   t.n9
                       RMA_NO,
                   t.n10
                       RMA_LINE_NO,
                   i.invoice_date
                       SALES_DATE,
                   CASE
                       WHEN t.net_curr_amount = 0
                       THEN
                           ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE (
                               t.invoice_id,
                               t.item_id,
                               t.c1)
                       ELSE
                           ifsapp.get_sbl_account_status (t.c1,
                                                          t.c2,
                                                          t.c3,
                                                          t.c5,
                                                          t.net_curr_amount,
                                                          i.invoice_date)
                   END
                       status,
                   t.identity
                       CUSTOMER_NO,
                   ifsapp.customer_info_api.Get_Name (t.identity)
                       CUSTOMER_NAME,
                   ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No (
                       t.identity)
                       phone_no,
                      IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1 (
                          t.identity,
                          1)
                   || ' '
                   || IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2 (
                          t.identity,
                          1)
                       dealer_address,
                   ifsapp.cust_ord_customer_api.get_cust_grp (t.identity)
                       CUSTOMER_GROUP,
                   (SELECT c.vendor_no
                      FROM ifsapp.CUSTOMER_ORDER_LINE_TAB c
                     WHERE     c.order_no = t.c1
                           AND c.line_no = t.c2
                           AND c.rel_no = t.c3
                           AND c.line_item_no = t.n1)
                       DELIVERY_SITE,
                   t.c5
                       PRODUCT_CODE,
                   t.c6
                       PRODUCT_DESC,
                   IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5)
                       CATALOG_TYPE,
                   IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description (
                       ifsapp.inventory_part_api.Get_Part_Product_Code (
                           t.c10,
                           t.c5))
                       brand,
                   ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description (
                       ifsapp.inventory_part_api.Get_Part_Product_Family (
                           t.c10,
                           t.c5))
                       product_family,
                   IFSAPP.COMMODITY_GROUP_API.Get_Description (
                       IFSAPP.INVENTORY_PART_API.Get_Second_Commodity (t.c10,
                                                                       t.c5))
                       commodity_group2,
                   CASE
                       WHEN t.net_curr_amount != 0
                       THEN
                             t.n2
                           * (t.net_curr_amount / ABS (t.net_curr_amount))
                       ELSE
                           IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (t.invoice_id,
                                                               t.item_id,
                                                               T.N2)    --t.n2
                   END
                       SALES_QUANTITY,
                   CASE
                       WHEN t.net_curr_amount < 0 AND t.n1 = 0
                       THEN
                             (SELECT l.base_sale_unit_price
                                FROM CUSTOMER_ORDER_LINE l
                               WHERE     l.order_no = t.c1
                                     AND l.line_no = t.c2
                                     AND l.rel_no = t.c3
                                     AND l.line_item_no = t.n1)
                           * (t.net_curr_amount / ABS (t.net_curr_amount))
                       WHEN t.net_curr_amount < 0 AND t.n1 > 0
                       THEN
                             (SELECT l.part_price
                                FROM CUSTOMER_ORDER_LINE l
                               WHERE     l.order_no = t.c1
                                     AND l.line_no = t.c2
                                     AND l.rel_no = t.c3
                                     AND l.line_item_no = t.n1)
                           * (t.net_curr_amount / ABS (t.net_curr_amount))
                       ELSE
                           (SELECT l.base_sale_unit_price
                              FROM CUSTOMER_ORDER_LINE l
                             WHERE     l.order_no = t.c1
                                   AND l.line_no = t.c2
                                   AND l.rel_no = t.c3
                                   AND l.line_item_no = t.n1)
                   END
                       UNIT_NSP,
                   ROUND (t.n5, 2)
                       DISCOUNT,
                   t.net_curr_amount
                       SALES_PRICE,
                   t.vat_code,
                   IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate ('SBL', t.vat_code)
                       vat_rate,
                   t.vat_curr_amount
                       VAT,
                   t.net_curr_amount + t.vat_curr_amount
                       RSP,
                   i.pay_term_id,
                   i.series_id,
                   i.invoice_no,
                   i.voucher_type_ref,
                   i.voucher_no_ref,
                   i.voucher_date_ref,
                   i.d2
                       rowversion
              FROM ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
             WHERE     t.invoice_id = i.invoice_id
                   --AND ifsapp.cust_ord_customer_api.get_cust_grp (t.identity) = '003'
                   AND EXISTS
                           (SELECT 1
                              FROM CUST_ORD_CUSTOMER_TAB COCT
                             WHERE     customer_no = t.identity
                                   AND COCT.cust_grp = '003')
                   AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   --AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) = 'INV'
                   AND EXISTS
                           (SELECT 1
                              FROM sales_part_tab spt
                             WHERE     spt.catalog_no = T.C5
                                   AND spt.catalog_type = 'INV')
                   AND t.rowstate = 'Posted') W
     WHERE w.site = 'SCSM' AND w.sales_price < 0;