/* Formatted on 5/17/2022 4:21:35 PM (QP5 v5.381) */
  SELECT COMPANY,
         VOUCHER_TYPE,
         VOUCHER_NO,
         VOUCHER_DATE,
         ACCOUNTING_YEAR,
         ACCOUNTING_PERIOD,
         YEAR_PERIOD_KEY,
         CORRECTION,
         ACCOUNT,
         ACCOUNT_DESC,
         CODE_B,
         CODE_B_DESC,
         CODE_C,
         CODE_C_DESC,
         CODE_D,
         CODE_D_DESC,
         CODE_E,
         CODE_F,
         CODE_F_DESC,
         CODE_G,
         CODE_G_DESC,
         CODE_H,
         CODE_I,
         CODE_J,
         DEBET_AMOUNT,
         CREDIT_AMOUNT,
         AMOUNT,
         CURRENCY_CODE,
         CURRENCY_DEBET_AMOUNT,
         CURRENCY_CREDIT_AMOUNT,
         CURRENCY_AMOUNT,
         CURRENCY_RATE,
         THIRD_CURRENCY_DEBIT_AMOUNT,
         THIRD_CURRENCY_CREDIT_AMOUNT,
         THIRD_CURRENCY_AMOUNT,
         TEXT,
         QUANTITY,
         PROCESS_CODE,
         OPTIONAL_CODE,
         PARTY_TYPE_ID,
         TRANS_CODE,
         TRANSFER_ID,
         CORRECTED,
         REFERENCE_SERIE,
         REFERENCE_NUMBER,
         MPCCOM_ACCOUNTING_ID,
         FUNCTION_GROUP
    FROM IFSAPP.GL_AND_HOLD_VOU_ROW_QRY
   WHERE     COMPANY = 'SBL'
         AND (    (    ACCOUNTING_YEAR = 2022
                   AND ACCOUNTING_PERIOD = 4
                   AND ACCOUNT = '10100060')
              AND ((    COMPANY = 'SBL'
                    AND ACCOUNTING_YEAR = 2022
                    AND ACCOUNTING_PERIOD = 4
                    AND ACCOUNT = '10100060')))
ORDER BY COMPANY,
         VOUCHER_TYPE,
         ACCOUNTING_YEAR,
         VOUCHER_NO