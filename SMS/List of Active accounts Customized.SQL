/* Formatted on 12/7/2022 9:06:14 AM (QP5 v5.381) */
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
       AND t.status = 'HireSale'
       AND IFSAPP.HPNRET_HP_HEAD_API.GET_OBJSTATE (t.order_no, 1) = 'Active'
       AND ( :p_shop_code IS NULL OR t.site = :p_shop_code)
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
       AND p.status = 'HireSale'
       AND IFSAPP.HPNRET_HP_HEAD_API.GET_OBJSTATE (p.order_no, 1) = 'Active'
       AND ( :p_shop_code IS NULL OR p.site = :p_shop_code)