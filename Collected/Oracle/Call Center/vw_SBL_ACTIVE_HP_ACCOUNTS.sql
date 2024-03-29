CREATE OR REPLACE VIEW SBL_ACTIVE_HP_ACCOUNTS AS
  SELECT H.YEAR,
         H.PERIOD,
         H.SHOP_CODE,
         H.ACCT_NO,
         --H.ORIGINAL_ACCT_NO,
         H.PRODUCT_CODE,
         /*IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(
           ifsapp.inventory_part_api.Get_Part_Product_Code(H.SHOP_CODE, H.PRODUCT_CODE)) BRAND,
         IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(
           IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(H.SHOP_CODE, H.PRODUCT_CODE)) PRODUCT_FAMILY,*/
         TO_CHAR(H.SALES_DATE, 'MM/DD/YYYY') SALES_DATE,
         /*TO_CHAR(H.ACTUAL_SALES_DATE, 'MM/DD/YYYY') ACTUAL_SALES_DATE,
         H.STATE,
         H.BB_NO,
         H.NORMAL_CASH_PRICE,
         H.DISCOUNT,
         H.VAT,
         H.AMOUNT_FINANCED,
         H.LOC,*/
         H.MONTHLY_PAY,
         H.DOWN_PAYMENT,
         --H.FIRST_PAY,
         H.COLLECTION,
         --H.TOTAL_UCC,
         H.ACT_OUT_BAL,
         H.ARR_AMT,
         H.ARR_MON,
         H.DEL_MON,
         --TO_CHAR(H.CASH_CONVERSION_ON_DATE, 'MM/DD/YYYY') CASH_CONVERSION_ON_DATE,
         --H.CUSTOMER,
         customer_info_api.Get_Name(Customer_Order_Api.Get_Customer_No(H.ACCT_NO)) Customer_Name,
         H.TEL_NO
  FROM   IFSAPP.HPNRET_FORM249_ARREARS_TAB H
  WHERE  --H.YEAR = '&YEAR_I' 
  --AND    H.PERIOD = '&PERIOD' 
  /*AND*/    H.ACCT_NO != 'SES-H320' 
  AND    H.ACT_OUT_BAL > 0
ORDER BY H.YEAR, H.PERIOD, H.SHOP_CODE, H.ORIGINAL_ACCT_NO, H.PRODUCT_CODE
