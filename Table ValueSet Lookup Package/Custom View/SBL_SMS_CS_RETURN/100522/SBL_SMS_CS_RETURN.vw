DROP VIEW IFSAPP.SBL_SMS_CS_RETURN;

CREATE OR REPLACE FORCE VIEW IFSAPP.SBL_SMS_CS_RETURN
(RMA_NO, SITE, ORDER_NO, LINE_NO, REL_NO, 
 RETURN_DATE, CUSTOMER_NO, CUSTOMER_NAME, PHONE_NO, DELIVERY_SITE, 
 PRODUCT_CODE, RETURNED_QUANTITY, UNIT_NSP, SALES_PRICE, VAT, 
 SALES_RETURN_AMOUNT)
AS 
SELECT w.rma_no,
           w.site,
           w.order_no,
           w.line_no,
           w.rel_no,
           w.sales_date return_date,
           w.customer_no,
           w.customer_name,
           (SELECT c.value
              FROM ifsapp.supplier_info_comm_method c
             WHERE c.supplier_id = w.customer_no
               AND c.method_id_db = 'PHONE') phone_no,
           w.delivery_site,
           w.product_code,
           w.sales_quantity returned_quantity,
           w.unit_nsp,
           w.sales_price,
           w.vat,
           w.rsp "SALES_RETURN_AMOUNT"
      FROM ifsapp.sbl_vw_wholesale_sales w
     WHERE w.site = 'SCSM'
       AND w.sales_price < 0;


GRANT SELECT ON IFSAPP.SBL_SMS_CS_RETURN TO SMS;
