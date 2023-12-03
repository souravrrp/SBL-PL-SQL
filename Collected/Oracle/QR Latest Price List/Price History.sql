--Price History
select T.PRICE_LIST_NO,
       T.CATALOG_NO,
       IFSAPP.SALES_PART_API.Get_Catalog_Desc('SCOM', T.CATALOG_NO) Catalog_Desc,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.CATALOG_NO),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                t.CATALOG_NO)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                    t.CATALOG_NO))) product_family,
       T.VALID_FROM_DATE,
       T.SALES_PRICE,
       T.CASH_TAX_CODE VAT_CODE/*,
       IFSAPP.Statutory_Fee_Api.Get_Fee_Rate('SBL', T.CASH_TAX_CODE) VAT_RATE*/
  from SALES_PRICE_LIST_PART_TAB t
 WHERE T.PRICE_LIST_NO like '&price_list_no'
   AND T.CATALOG_NO LIKE '&product_code'
 ORDER BY 4, 2, 5
