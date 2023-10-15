/* Formatted on 8/22/2023 2:16:21 PM (QP5 v5.381) */
SELECT T2.CONTRACT
           SENDER,
       (SELECT ADDRESS1 || ' ' || ADDRESS2
          FROM IFSAPP.CUSTOMER_INFO_ADDRESS_TAB CA
         WHERE CA.CUSTOMER_ID = T2.CONTRACT)
           SENDER_ADDRESS,
       T2.CUSTOMER_NO
           RECIPIENT,
       (SELECT ADDRESS1 || ' ' || ADDRESS2
          FROM IFSAPP.CUSTOMER_INFO_ADDRESS_TAB CA
         WHERE CA.CUSTOMER_ID = T2.CUSTOMER_NO)
           RECIPIENT_ADDRESS,
       T2.DEMAND_ORDER_REF1
           PO_NUMBER,
       T4.ORDER_NO,
          T2.PART_NO
       || ' - '
       || T2.CATALOG_DESC
       || ' / '
       || IFSAPP.SERIAL_OEM_CONN_API.GET_OEM_NO (L.PART_NO, L.SERIAL_NO)
           PRODUCT_DESCRIPTION,
       --       (SELECT VALUE_WITHOUT_TAX
       --          FROM (SELECT ROW_NUMBER ()
       --                           OVER (PARTITION BY P.CATALOG_NO, P.PRICE_LIST_NO
       --                                 ORDER BY P.VALID_FROM_DATE DESC)    ROW_NUM,
       --                       P.BASE_PRICE                                  VALUE_WITHOUT_TAX
       --                  FROM IFSAPP.SALES_PRICE_LIST_PART_TAB P
       --                 WHERE     1 = 1
       --                       AND P.CATALOG_NO = T2.PART_NO
       --                       AND P.VALID_FROM_DATE <= T4.DATE_DELIVERED
       --                       AND P.PRICE_LIST_NO = 3)
       --         WHERE ROW_NUM < 2)
       VALUE_WITHOUT_TAX,
       T4.DELNOTE_NO,
       T4.QTY_SHIPPED,
       T4.DATE_DELIVERED,
       --IFSAPP.SERIAL_OEM_CONN_API.GET_OEM_NO (L.PART_NO, L.SERIAL_NO) OEM_NO,
       (SELECT PIT.NAME
          FROM PERSON_INFO_TAB PIT
         WHERE PIT.PERSON_ID = L.SOURCE)
           FULL_NAME
  --,T2.*
  FROM IFSAPP.CUSTOMER_ORDER_DELIVERY_TAB    T4,
       IFSAPP.CUSTOMER_ORDER_LINE_TAB        T2,
       IFSAPP.CUSTOMER_ORDER_RES_SERIAL_LOV  L,
       (SELECT VALUE_WITHOUT_TAX, CATALOG_NO, VALID_FROM_DATE
          FROM (SELECT ROW_NUMBER ()
                           OVER (PARTITION BY P.CATALOG_NO, P.PRICE_LIST_NO
                                 ORDER BY P.VALID_FROM_DATE DESC)    ROW_NUM,
                       P.CATALOG_NO,
                       P.VALID_FROM_DATE,
                       P.BASE_PRICE                                  VALUE_WITHOUT_TAX
                  FROM IFSAPP.SALES_PRICE_LIST_PART_TAB P
                 WHERE 1 = 1 AND P.PRICE_LIST_NO = 3)
         WHERE ROW_NUM < 2) p
 WHERE     T2.ORDER_NO = T4.ORDER_NO
       AND T2.LINE_NO = T4.LINE_NO
       AND T2.REL_NO = T4.REL_NO
       AND T2.LINE_ITEM_NO = T4.LINE_ITEM_NO
       AND T2.DEMAND_ORDER_REF1 LIKE '&PO_NO'
       AND T2.ORDER_NO = L.ORDER_NO
       AND T2.LINE_NO = L.LINE_NO
       AND T2.REL_NO = L.REL_NO
       AND T2.LINE_ITEM_NO = L.LINE_ITEM_NO
       AND P.CATALOG_NO = T2.PART_NO
       AND P.VALID_FROM_DATE <= T4.DATE_DELIVERED;