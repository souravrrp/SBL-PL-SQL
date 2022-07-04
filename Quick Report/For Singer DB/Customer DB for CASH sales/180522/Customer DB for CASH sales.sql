/* Formatted on 5/18/2022 2:36:30 PM (QP5 v5.381) */
SELECT t.site,
       t.order_no,
       t.product_code,
       ifsapp.inventory_part_api.Get_Prime_Commodity (t.site, t.product_code)
           PROD_GROUP,
       TO_CHAR (TRUNC (t.sales_date), 'YYYY-MM-DD')
           Sale_Date,
       t.status,
       t.customer_no,
       IFSAPP.CUSTOMER_INFO_API.Get_Name (t.customer_no)
           CUSTOMER_NAME,
       r.VALUE
           MOBILE_NO
  FROM IFSAPP.SBL_JR_SALES_DTL_INV t, IFSAPP.CUSTOMER_INFO_COMM_METHOD r
 WHERE     t.customer_no = r.customer_id
       AND ifsapp.inventory_part_api.Get_Prime_Commodity (t.site,
                                                          t.product_code) LIKE
               ('&PROD_GROUP')
       AND t.sales_date BETWEEN TO_DATE ('&FROM_DATE', 'YYYY/MM/DD')
                            AND TO_DATE ('&TO_DATE', 'YYYY/MM/DD')
       AND t.site LIKE '&SITE'
       AND t.status = 'CashSale'
UNION ALL
SELECT p.site,
       p.order_no,
       p.product_code,
       ifsapp.inventory_part_api.Get_Prime_Commodity (p.site, p.product_code)
           PROD_GROUP,
       TO_CHAR (TRUNC (p.sales_date), 'YYYY-MM-DD')
           Sale_Date,
       p.status,
       p.customer_no,
       ifsapp.customer_info_api.Get_Name (p.customer_no),
       r.VALUE
           MOBILE_NO
  FROM IFSAPP.SBL_JR_SALES_DTL_PKG_COMP p, IFSAPP.CUSTOMER_INFO_COMM_METHOD r
 WHERE     p.customer_no = r.customer_id
       AND ifsapp.inventory_part_api.Get_Prime_Commodity (p.site,
                                                          p.product_code) LIKE
               ('&PROD_GROUP')
       AND p.sales_date BETWEEN TO_DATE ('&FROM_DATE', 'YYYY/MM/DD')
                            AND TO_DATE ('&TO_DATE', 'YYYY/MM/DD')
       AND p.site LIKE '&SITE'
       AND p.status = 'CashSale'