select t.shop_code,
       t.area_code,
       t.district_code,
       t.delivery_site,
       t.brand,
       t.product_family,
       t.product_family_description,
       t.comm_group_2,
       t.part_no,
       t.serial_no,
       t.Oem_No,
       t.qty_onhand,
       t.receipt_date,
       t.age,
       t.age_month,
       t.NSP,
       t.VAT_CODE,
       t.VAT,
              
       (SELECT i.COST from ifsapp.INVENT_ONLINE_COST_TAB i 
       where i.contract=t.shop_code 
       and i.part_no=t.part_no
       and i.year=extract(year from (trunc(TO_DATE('&DATE', 'YYYY/MM/DD'), 'MM')-1))
       and i.period=extract(month from (trunc(TO_DATE('&DATE', 'YYYY/MM/DD'), 'MM')-1))) AS UNIT_COST
       
FROM ifsapp.SBL_VW_PRODUCT_AGING t
/*INNER JOIN INVENT_ONLINE_COST_TAB i
ON t.part_no=i.part_no*/
WHERE t.shop_code='&SHOP_CODE'

