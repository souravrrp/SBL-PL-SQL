/* Formatted on 9/21/2023 10:08:47 AM (QP5 v5.381) */
SELECT T2.CONTRACT                                 SENDER,
       (SELECT ADDRESS1 || ' ' || ADDRESS2
          FROM IFSAPP.CUSTOMER_INFO_ADDRESS_TAB CA
         WHERE CA.CUSTOMER_ID = T2.CONTRACT)       SENDER_ADDRESS,
       T2.CUSTOMER_NO                              RECIPIENT,
       (SELECT ADDRESS1 || ' ' || ADDRESS2
          FROM IFSAPP.CUSTOMER_INFO_ADDRESS_TAB CA
         WHERE CA.CUSTOMER_ID = T2.CUSTOMER_NO)    RECIPIENT_ADDRESS,
       T2.DEMAND_ORDER_REF1                        PO_NUMBER,
       T4.ORDER_NO,
       T4.DELNOTE_NO,
       T4.DATE_DELIVERED
  FROM IFSAPP.CUSTOMER_ORDER_DELIVERY_TAB  T4,
       IFSAPP.CUSTOMER_ORDER_LINE_TAB      T2
 WHERE     T2.ORDER_NO = T4.ORDER_NO
       AND T2.LINE_NO = T4.LINE_NO
       AND T2.REL_NO = T4.REL_NO
       AND T2.LINE_ITEM_NO = T4.LINE_ITEM_NO
       --AND T4.DELNOTE_NO = :P_DELNOTE_NO
       AND T2.DEMAND_ORDER_REF1 = :P_PO_NO;