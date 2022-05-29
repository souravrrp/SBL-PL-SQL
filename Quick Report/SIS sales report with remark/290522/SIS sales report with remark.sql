/* Formatted on 5/29/2022 2:30:11 PM (QP5 v5.381) */
SELECT t.ORDER_NO,
       t.CONTRACT,
       TO_CHAR (C.REAL_SHIP_DATE, 'dd/mm/yyyy')
           SALE_DATE,
       t.CUSTOMER_NO,
       IFSAPP.customer_info_api.Get_Name (t.CUSTOMER_NO)
           CUST_NAME,
       IFSAPP.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No (t.CUSTOMER_NO)
           PHONE_NO,
       'Cash Sale'
           Sale_TYPE,
       c.CATALOG_NO
           PRODUCT_CODE,
       c.buy_qty_due
           QTY,
       t.REMARKS
  FROM IFSAPP.HPNRET_CUSTOMER_ORDER t, IFSAPP.customer_order_line_tab c
 WHERE     c.ORDER_NO = t.ORDER_NO
       AND C.REAL_SHIP_DATE BETWEEN TO_DATE ('&DATE_FROM', 'dd/mm/yyyy')
                                AND TO_DATE ('&DATE_TO', 'dd/mm/yyyy')
       AND cust_ord_customer_api.get_cust_grp (t.CUSTOMER_NO) <> '003'
       AND c.SALE_UNIT_PRICE > 0
       AND c.CATALOG_TYPE <> 'KOMP'
       --and t.REMARKS is not null
       AND t.CONTRACT LIKE '&site'
       AND SUBSTR (t.REMARKS, 0, 14) NOT LIKE 'Cash Converted'
       AND t.ORDER_NO IN
               (SELECT t.ORDER_NO
                  FROM IFSAPP.CUSTOMER_ORDER_TAB O
                 WHERE O.ORDER_NO = t.ORDER_NO AND o.CUSTOMER_PO_NO IS NULL)
UNION ALL
SELECT c.Account_No,
       c.CONTRACT,
       TO_CHAR (c.SALES_DATE, 'dd/mm/yyyy')
           SALE_DATE,
       t.ID,
       IFSAPP.customer_info_api.Get_Name (t.ID)
           NAME,
       IFSAPP.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No (t.ID)
           PHONE_NO,
       'Hire Sale'
           Sale_TYPE,
       c.CATALOG_NO,
       c.QUANTITY,
       t.REMARKS
  FROM IFSAPP.hpnret_hp_dtl_tab c, IFSAPP.HPNRET_HP_HEAD_TAB t
 WHERE     t.Account_No = c.Account_No
       AND c.SALES_DATE BETWEEN TO_DATE ('&DATE_FROM', 'dd/mm/yyyy')
                            AND TO_DATE ('&DATE_TO', 'dd/mm/yyyy')
       AND c.SALE_UNIT_PRICE > 0
       AND c.CONTRACT LIKE '&site'
       AND c.CATALOG_TYPE <> 'KOMP'
       AND t.ROWSTATE NOT IN ('CashConverted',
                              'Returned',
                              'RevertReversed',
                              'Cancelled');