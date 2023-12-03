SELECT *
  FROM (SELECT T.CHECK_ENCASHMENT_CODE,
               T.AMOUNT COMMISSION,
               nvl(decode(t.CHECK_ENCASHMENT_CODE,
                          'NOKIA GIFT VOUCHER',
                          t.AMOUNT,
                          'NOKIA GIFT VOUCHER-H',
                          t.AMOUNT),
                   0) + nvl(decode(t.CHECK_ENCASHMENT_CODE,
                                   'CASH-CC',
                                   t.AMOUNT * .4,
                                   'EMCC',
                                   t.AMOUNT * .4),
                            0) DEDUCTABLE,
               T.PAYMENT_DATE,
               T.ORDER_NO,
               T.USER_ID
          FROM IFSAPP.CHECK_ENCASHMENT T
         WHERE TO_DATE('&START_DATE', 'yyyy/mm/dd') <=
               T.PAYMENT_DATE
           AND T.PAYMENT_DATE <=
               TO_DATE('&END_DATE', 'YYYY/MM/DD')
           AND T.STATE = 'Approved'
           and t.CHECK_ENCASHMENT_CODE in
               ('NOKIA GIFT VOUCHER', 'NOKIA GIFT VOUCHER-H')
        union all
        SELECT T.DISCOUNT_TYPE,
               T.DISCOUNT_AMOUNT,
               decode(T.DISCOUNT_TYPE,
                      '800',
                      T.DISCOUNT_AMOUNT,
                      'ED',
                      T.DISCOUNT_AMOUNT,
                      'G',
                      T.DISCOUNT_AMOUNT,
                      'GF',
                      T.DISCOUNT_AMOUNT,
                      'MD',
                      T.DISCOUNT_AMOUNT,
                      'MD-DENT/DMGD PRODUCT',
                      T.DISCOUNT_AMOUNT,
                      'MD-REV REFIX',
                      T.DISCOUNT_AMOUNT) +
               decode(substr(T.DISCOUNT_TYPE, 1, 3),
                      'FC_',
                      T.DISCOUNT_AMOUNT,
                      'HC_',
                      T.DISCOUNT_AMOUNT * .5,
                      'PR_',
                      T.DISCOUNT_AMOUNT) DEDUCTABLE,
               t.rowversion "SALES_DATE",
               T.ORDER_NO,
               t.user_id
          FROM CUST_ORDER_LINE_DISCOUNT_TAB T
         WHERE TO_DATE('&START_DATE', 'yyyy/mm/dd') <=
               t.rowversion
           AND t.rowversion <=
               TO_DATE('&END_DATE', 'YYYY/MM/DD'))
 WHERE nvl(DEDUCTABLE, 0) > 0
