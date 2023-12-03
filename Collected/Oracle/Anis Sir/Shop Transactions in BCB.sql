select B.CONTRACT SHOP_CODE,
       B.BCB_STATEMENT_NO,
       D.VOUCHER_TYPE,
       D.VOUCHER_NO,
       TO_CHAR(D.VOUCHER_DATE, 'YYYY/MM/DD') VOUCHER_DATE,
       D.CO_NUMBER,
       D.HP_ACC_NUMBER,
       D.HP_ACC_REV,
       D.RECEIPT_NO,
       --D.RECEIPT_DATE,
       D.REMARKS,
       D.TRANSACTION_CODE,
       IFSAPP.SITE_TRANSACTION_TYPES_API.Get_Transaction_Type('SBL',
                                                              D.TRANSACTION_CODE) TRANSACTION_DESC,
       D.IDENTITY,
       D.PARTY_TYPE,
       D.LEDGER_ITEM_SERIES_ID,
       D.LEDGER_ITEM_ID,
       D.DOM_AMOUNT,
       D.CURR_AMOUNT,
       D.TRANSFERED_AMOUNT,
       D.ROWSTATE
  from IFSAPP.BCB_STATEMENT_DETAILS_TAB D
 INNER JOIN IFSAPP.BCB_STATEMENT_TAB B
    ON D.COMPANY = B.COMPANY
   AND D.BCB_STATEMENT_ID = B.BCB_STATEMENT_ID
 WHERE /*B.BCB_STATEMENT_NO = 'TONBCB-560'*/
   /*AND D.CO_NUMBER = 'ANW-R4497'*/
   /*AND*/ B.CONTRACT = 'TOND'
   /*AND (D.TRANSACTION_CODE NOT LIKE 'BL%' OR D.TRANSACTION_CODE IS NULL)
   AND D.ROWSTATE = 'Transfered'
   AND D.VOUCHER_TYPE = 'N'
   AND D.VOUCHER_NO = 1601281661*/
   AND TRUNC(D.VOUCHER_DATE) BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND TO_DATE('&TO_DATE', 'YYYY/MM/DD')