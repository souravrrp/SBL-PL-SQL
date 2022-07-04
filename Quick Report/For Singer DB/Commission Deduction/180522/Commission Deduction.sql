/* Formatted on 5/18/2022 11:15:42 AM (QP5 v5.381) */
SELECT *
  FROM (SELECT T.CHECK_ENCASHMENT_CODE,
               T.AMOUNT    COMMISSION,
                 NVL (
                     DECODE (t.CHECK_ENCASHMENT_CODE,
                             'NOKIA GIFT VOUCHER', t.AMOUNT,
                             'NOKIA GIFT VOUCHER-H', t.AMOUNT),
                     0)
               + NVL (
                     DECODE (t.CHECK_ENCASHMENT_CODE,
                             'CASH-CC', t.AMOUNT * .4,
                             'EMCC', t.AMOUNT * .4),
                     0)    DEDUCTABLE,
               T.PAYMENT_DATE,
               T.ORDER_NO,
               T.USER_ID
          FROM IFSAPP.CHECK_ENCASHMENT T
         WHERE     TO_DATE ('&START_DATE_yyy/mm/dd', 'yyyy/mm/dd') <=
                   T.PAYMENT_DATE
               AND T.PAYMENT_DATE <=
                   TO_DATE (' &END_DATE_yyy/mm/dd ', ' YYYY / MM / DD ')
               AND T.STATE = 'Approved'
               AND t.CHECK_ENCASHMENT_CODE IN
                       ('NOKIA GIFT VOUCHER', 'NOKIA GIFT VOUCHER-H')
        UNION ALL
        SELECT T.DISCOUNT_TYPE,
               T.DISCOUNT_AMOUNT,
                 DECODE (T.DISCOUNT_TYPE,
                         '800', T.DISCOUNT_AMOUNT,
                         'ED', T.DISCOUNT_AMOUNT,
                         'G', T.DISCOUNT_AMOUNT,
                         'GF', T.DISCOUNT_AMOUNT,
                         'MD', T.DISCOUNT_AMOUNT,
                         'MD-DENT/DMGD PRODUCT', T.DISCOUNT_AMOUNT,
                         'MD-REV REFIX', T.DISCOUNT_AMOUNT)
               + DECODE (SUBSTR (T.DISCOUNT_TYPE, 1, 3),
                         'FC_', T.DISCOUNT_AMOUNT,
                         'HC_', T.DISCOUNT_AMOUNT * .5,
                         'PR_', T.DISCOUNT_AMOUNT)    DEDUCTABLE,
               t.rowversion                           "SALES_DATE",
               T.ORDER_NO,
               t.user_id
          FROM IFSAPP.CUST_ORDER_LINE_DISCOUNT_TAB T
         WHERE     TO_DATE ('&START_DATE_yyy/mm/dd', 'yyyy/mm/dd') <=
                   t.rowversion
               AND t.rowversion <=
                   TO_DATE (' &END_DATE_yyy/mm/dd ', ' YYYY / MM / DD '))
 WHERE NVL (DEDUCTABLE, 0) > 0