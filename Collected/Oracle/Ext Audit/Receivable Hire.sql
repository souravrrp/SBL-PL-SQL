--***** Receivable Hire SM & FUR
SELECT H.YEAR,
       H.PERIOD,
       H.SHOP_CODE,
       H.ORIGINAL_ACCT_NO,
       H.ACCT_NO,
       H.PRODUCT_CODE,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(H.PRODUCT_CODE),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                H.PRODUCT_CODE)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                    H.PRODUCT_CODE))) product_family,
       TO_CHAR(H.SALES_DATE, 'MM/DD/YYYY') SALES_DATE,
       H.ACT_OUT_BAL RECEIVABLE
  FROM HPNRET_FORM249_ARREARS_TAB H
 WHERE H.YEAR = '&YEAR_I'
   AND H.PERIOD = '&PERIOD'
   AND H.ACT_OUT_BAL > 0
   AND (H.Product_Code LIKE 'SRSM-%' OR H.PRODUCT_CODE LIKE '%FUR-%')
 ORDER BY H.YEAR, H.PERIOD, H.SHOP_CODE, H.ACCT_NO, H.PRODUCT_CODE
