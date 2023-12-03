select S.INVOICE_ID,
       S.SITE,
       S.ORDER_NO,
       S.STATUS,
       (select trunc(d.sales_date)
          from HPNRET_HP_DTL_TAB d
         where d.account_no = S.ORDER_NO
           and d.ref_line_no = S.LINE_NO
           and d.ref_rel_no = S.REL_NO
           and d.catalog_no = S.PRODUCT_CODE) SALES_DATE,
       (select H.ORIGINAL_SALES_DATE
          from HPNRET_HP_HEAD_TAB H
         WHERE H.ACCOUNT_NO = S.ORDER_NO) ACTUAL_SALES_DATE,
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
       (select D.AMT_FINANCE
          from HPNRET_HP_DTL_TAB d
         where d.account_no = S.ORDER_NO
           and d.ref_line_no = S.LINE_NO
           and d.ref_rel_no = S.REL_NO
           and d.catalog_no = S.PRODUCT_CODE) AMT_FINANCE,
       (select D.DOWN_PAYMENT
          from HPNRET_HP_DTL_TAB d
         where d.account_no = S.ORDER_NO
           and d.ref_line_no = S.LINE_NO
           and d.ref_rel_no = S.REL_NO
           and d.catalog_no = S.PRODUCT_CODE) DOWN_PAYMENT,
       (select H.LENGTH_OF_CONTRACT
          from HPNRET_HP_HEAD_TAB H
         WHERE H.ACCOUNT_NO = S.ORDER_NO) LENGTH_OF_CONTRACT,
       (select D.INSTALL_AMT
          from HPNRET_HP_DTL_TAB d
         where d.account_no = S.ORDER_NO
           and d.ref_line_no = S.LINE_NO
           and d.ref_rel_no = S.REL_NO
           and d.catalog_no = S.PRODUCT_CODE) INSTALL_AMT,
       (select D.SERVICE_CHARGE
          from HPNRET_HP_DTL_TAB d
         where d.account_no = S.ORDER_NO
           and d.ref_line_no = S.LINE_NO
           and d.ref_rel_no = S.REL_NO
           and d.catalog_no = S.PRODUCT_CODE) SERVICE_CHARGE,
       (SELECT TRUNC(H.CASH_CONVERSION_ON_DATE)
          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H
         WHERE H.YEAR = EXTRACT(YEAR FROM S.SALES_DATE)
           AND H.PERIOD = EXTRACT(MONTH FROM S.SALES_DATE)
           AND H.ACCT_NO = S.ORDER_NO
           AND H.ACT_OUT_BAL = 0
           AND H.LAST_VARIATION = 'CashConverted') ORG_CASH_CONV_DATE,
       S.SALES_DATE ACT_CASH_CONV_DATE
  from SBL_JR_SALES_DTL_INV S
 INNER JOIN SBL_JR_PRODUCT_DTL_INFO P
    ON S.PRODUCT_CODE = P.PRODUCT_CODE
 where (S.STATUS = 'CashConverted' or S.Status is null)
   AND S.SALES_DATE BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
