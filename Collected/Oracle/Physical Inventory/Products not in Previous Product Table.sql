-- Products not in Previous Product Table
select a.*,
       p.*
  from (select p.product_code
          from SBL_JR_PRODUCT_DTL_INFO p
        minus
        select c.product_code from product_category_info c) a inner join 
        SBL_JR_PRODUCT_DTL_INFO p on
        a.product_code = p.product_code
 order by 7

-- Raw Materials Not Included in Count Table
select T.PART_NO
  from INVENTORY_PART_TAB t
 WHERE T.CONTRACT = 'SCOM'
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', t.part_no) =
       'RAW'
MINUS
select P.PRODUCT_CODE from PRODUCT_CATEGORY_INFO P
ORDER BY 1

-- Spare Parts Not Included in Count Table
select T.PART_NO
  from INVENTORY_PART_TAB t
 WHERE T.CONTRACT = 'DSCP'
   and ifsapp.inventory_part_api.Get_Second_Commodity('DSCP', T.part_no) like
       'S-%'
MINUS
select P.PRODUCT_CODE from PRODUCT_CATEGORY_INFO P WHERE P.GROUP_NO = 132;

-- Spare Parts Not Included in DSCP
select P.PRODUCT_CODE from PRODUCT_CATEGORY_INFO P WHERE P.GROUP_NO = 132
MINUS
select T.PART_NO
  from INVENTORY_PART_TAB t
 WHERE T.CONTRACT = 'DSCP'
   and ifsapp.inventory_part_api.Get_Second_Commodity('DSCP', T.part_no) like
       'S-%'
