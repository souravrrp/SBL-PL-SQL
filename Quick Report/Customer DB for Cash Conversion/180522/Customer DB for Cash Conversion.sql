/* Formatted on 5/18/2022 3:48:45 PM (QP5 v5.381) */
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
       AND t.status = 'CashConverted'