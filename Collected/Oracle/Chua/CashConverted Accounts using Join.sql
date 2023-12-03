--CashConverted Accounts using Join (Faster)
SELECT A.INVOICE_ID,
       A.SITE,
       A.ORDER_NO,
       A.STATUS,
       B.SALES_DATE,
       B.ACTUAL_SALES_DATE,
       A.CUSTOMER_NO,
       A.CUSTOMER_NAME,
       A.PRODUCT_CODE,
       A.PRODUCT_FAMILY,
       A.COMMODITY_GROUP2,
       A.sales_group,
       A.Catalog_Type,
       A.SALES_QUANTITY,
       A.SALES_PRICE,
       A.UNIT_NSP,
       A.DISCOUNT,
       A.VAT,
       A.AMOUNT_RSP,
       B.AMOUNT_FINANCED,
       B.DOWN_PAYMENT,
       B.LOC,
       B.MONTHLY_PAY,
       A.SERVICE_CHARGE,
       B.CASH_CONVERSION_ON_DATE ORG_CASH_CONV_DATE,
       A.ACT_CASH_CONV_DATE
  FROM (select S.INVOICE_ID,
               S.SITE,
               S.ORDER_NO,
               S.STATUS,
               S.CUSTOMER_NO,
               ifsapp.customer_info_api.Get_Name(S.CUSTOMER_NO) CUSTOMER_NAME,
               S.PRODUCT_CODE,
               P.PRODUCT_FAMILY,
               P.COMMODITY_GROUP2,
               IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                              S.PRODUCT_CODE)) sales_group,
               IFSAPP.SALES_PART_API.Get_Catalog_Type(S.PRODUCT_CODE) Catalog_Type,
               S.SALES_QUANTITY,
               S.SALES_PRICE,
               S.UNIT_NSP,
               S.DISCOUNT,
               S.VAT,
               S.AMOUNT_RSP,
               (select D.SERVICE_CHARGE
                  from HPNRET_HP_DTL_TAB d
                 where d.account_no = S.ORDER_NO
                   and d.ref_line_no = S.LINE_NO
                   and d.ref_rel_no = S.REL_NO
                   and d.catalog_no = S.PRODUCT_CODE) SERVICE_CHARGE,
               S.SALES_DATE ACT_CASH_CONV_DATE
          from SBL_JR_SALES_DTL_INV S
         INNER JOIN SBL_JR_PRODUCT_DTL_INFO P
            ON S.PRODUCT_CODE = P.PRODUCT_CODE
         where (S.STATUS = 'CashConverted' or S.Status is null)
           AND S.SALES_DATE BETWEEN TO_DATE('&YEAR_I'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD') AND
               LAST_DAY(TO_DATE('&YEAR_I'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD'))) A
 LEFT JOIN (SELECT H.YEAR,
                    H.PERIOD,
                    H.SHOP_CODE,
                    H.ACCT_NO,
                    H.PRODUCT_CODE,
                    H.ACTUAL_SALES_DATE,
                    H.SALES_DATE,
                    H.CLOSED_DATE,
                    H.STATE,
                    H.LAST_VARIATION,
                    H.BB_NO,
                    H.CUSTOMER,
                    H.NORMAL_CASH_PRICE,
                    H.HIRE_CASH_PRICE,
                    H.HIRE_PRICE,
                    H.LIST_PRICE,
                    H.AMOUNT_FINANCED,
                    H.MONTHLY_PAY,
                    H.FIRST_PAY,
                    H.DOWN_PAYMENT,
                    H.COLLECTION,
                    H.LOC,
                    H.DISCOUNT,
                    H.TOTAL_UCC,
                    H.ARR_AMT,
                    H.ARR_MON,
                    H.DEL_MON,
                    H.ACT_OUT_BAL,
                    H.CASH_CONVERSION_ON_DATE
               FROM HPNRET_FORM249_ARREARS_TAB H
              WHERE H.YEAR = '&YEAR_I'
                AND H.PERIOD = '&PERIOD'
                AND H.ACT_OUT_BAL = 0
                AND H.LAST_VARIATION = 'CashConverted'
             /*AND H.STATE != 'Closed'
             AND (select R.ROWSTATE
                    from HPNRET_HP_HEAD_TAB R
                   where R.account_no = H.ACCT_NO) != 'Closed'*/
             ) B
    ON A.ORDER_NO = B.ACCT_NO
