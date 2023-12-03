SELECT H.YEAR,
       H.PERIOD,
       /*(select s.area_code
          from SHOP_DTS_INFO s
         where s.shop_code = H.shop_code) area_code,*/
       /*(select s.district_code
          from SHOP_DTS_INFO s
         where s.shop_code = H.shop_code) district_code,*/
       H.SHOP_CODE,
       H.ORIGINAL_ACCT_NO,
       H.ACCT_NO,
       H.PRODUCT_CODE,
       --IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(H.SHOP_CODE, H.PRODUCT_CODE)) product_family,
       --IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(H.SHOP_CODE, H.PRODUCT_CODE)) commodity_group,
       H.MORE_PRODUCTS,
       H.SALESMAN,
       H.SALES_CREATOR,
       H.HP_TYPE,
       TO_CHAR(H.ACTUAL_SALES_DATE, 'MM/DD/YYYY') ACTUAL_SALES_DATE,
       TO_CHAR(H.SALES_DATE, 'MM/DD/YYYY') SALES_DATE,
       TO_CHAR(H.REAL_SHIP_DATE, 'MM/DD/YYYY') REAL_SHIP_DATE,
       TO_CHAR(H.CLOSED_DATE, 'MM/DD/YYYY') CLOSED_DATE,
       H.STATE,
       H.LAST_VARIATION,
       H.BB_NO,
       --IFSAPP.HPNRET_BB_MAIN_HEAD_API.Get_Description(H.BB_NO) BB_NAME,
       /*IFSAPP.HPNRET_HP_HEAD_API.Get_Total_Discount_Amt(H.ACCT_NO, 1) DISCOUNT,*/
       /*IFSAPP.HPNRET_HP_HEAD_API.Get_Total_Serv_Chg(H.ACCT_NO, 1) SERVICE_CHARGE,*/
       H.SCHEME,
       H.GROUP_SALE_NO,
       H.CUSTOMER,
       IFSAPP.CUSTOMER_INFO_API.Get_NIC_No(H.CUSTOMER) NIC,
       --IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(H.CUSTOMER, 1) ADDRESS_1,
       --IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(H.CUSTOMER, 1) ADDRESS_2,
       H.ORDER_TYPE,
       H.MC_CD,
       H.NORMAL_CASH_PRICE,
       H.HIRE_CASH_PRICE,
       H.HIRE_PRICE,
       H.LIST_PRICE,
       H.AMOUNT_FINANCED,
       H.MONTHLY_PAY,
       H.FIRST_PAY,
       H.DOWN_PAYMENT,
       H.SURAKSHA_AMOUNT,
       H.SANASUMA_AMOUNT,
       H.COMMODITY2,
       H.COLLECTION,
       H.LOC,
       H.DISCOUNT,
       H.TOTAL_UCC,
       H.ARR_AMT,
       H.ARR_MON,
       H.OUTSTANDING_BAL,
       H.OUTSTANDING_MONTHS,
       H.OUTSTANDING_UCC,
       REPLACE(H.TEL_NO, ',', '_') TEL_NO,
       H.DEL_MON,
       to_char(H.ROWVERSION, 'MM/DD/YYYY') ROWVERSION,
       H.ACT_OUT_BAL,
       H.VAT,
       TO_CHAR(H.CASH_CONVERSION_ON_DATE, 'MM/DD/YYYY') CASH_CONVERSION_ON_DATE,
       H.EFFECTIVE_RATE,
       H.PRESENT_VALUE,
       H.ACTUAL_UCC,
       H.EFFECTIVE_ECC
       /*COUNT(*)*/
  FROM HPNRET_FORM249_ARREARS_TAB H
 WHERE H.YEAR = '&YEAR_I'
   AND H.PERIOD = '&PERIOD'
   AND H.ACT_OUT_BAL > 0
   --AND H.MONTHLY_PAY = 0
   --AND IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(H.CUSTOMER, 1) IS NULL
   --AND IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(H.CUSTOMER, 1) IS NULL
   /*and H.SHOP_CODE not in ('BSCP',
                           'BLSP',
                           'CSCP',
                           'DSCP',
                           'JSCP',
                           'RSCP',
                           'SSCP',
                           'MS1C',
                           'MS2C',
                           'BTSC')*/ --Service Sites
   --and H.SHOP_CODE not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
   --and H.SHOP_CODE not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM') --Corporate, Employee, & Scrap Sites
   /*AND H.BB_NO = 'GR-19'*/
   /*AND H.ACCT_NO = 'SFI-H3351'*/ --'RUH-H2274'
   --AND TRUNC(H.CASH_CONVERSION_ON_DATE) > TO_DATE('2015/12/31', 'YYYY/MM/DD')
   --AND H.SHOP_CODE LIKE '&SHOP_CODE'
   /*AND H.GROUP_SALE_NO IS NOT NULL*/
 ORDER BY H.YEAR, H.PERIOD, H.SHOP_CODE, H.ORIGINAL_ACCT_NO, H.PRODUCT_CODE