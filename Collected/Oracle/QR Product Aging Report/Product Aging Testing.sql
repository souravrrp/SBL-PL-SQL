--Product Aging Summary Test
select
    --v.shop_code,
    v.product_family,
    v.product_family_description,
    sum(v.qty_onhand) qty_onhand--,
    --v.age_month
from IFSAPP.sbl_vw_product_aging v
WHERE
  v.shop_code like '&shop_code' AND
  --v.product_family like '&product_family' and
  v.product_family in ('ACSPT', 'ACST', 'ACWD', 'ACWND') and
  v.part_no like '&part_no'
group by /*v.shop_code,*/ v.product_family, v.product_family_description--, v.age_month
order by /*v.shop_code,*/ v.product_family--, v.age_month

--Product Aging Details Test
select
    v.shop_code,
    v.product_family,
    v.product_family_description,
    v.part_no,
    --v.serial_no,
    --v.Oem_No,
    sum(v.qty_onhand) total_qty_onhand,
    --v.receipt_date,
    --v.age,
    --v.age_month
    (select t.cost from invent_online_cost_tab t where t.year = 2015 and t.period = 1 and t.contract = v.shop_code and t.part_no = v.part_no) "COST",
    sum(v.qty_onhand) * (select t.cost from invent_online_cost_tab t where t.year = 2015 and t.period = 1 and t.contract = v.shop_code and t.part_no = v.part_no) total_cost
from sbl_vw_product_aging v
WHERE 
  v.shop_code like '&shop_code' AND
  --v.product_family like '&product_family' and
  --v.product_family in ('ACSPT', 'ACST', 'ACWD', 'ACWND') and
  v.part_no like '&part_no' and
  v.age >= 270
group by v.shop_code, v.product_family, v.product_family_description, v.part_no
order by v.shop_code, v.product_family, v.product_family_description, v.part_no--, v.receipt_date


--Inventory Report Testing
select 
    AREA_CODE,
    GROUP_NO,
    sum(QTY_ONHAND) as ONHAND 
from
  IFSAPP.INVENTORY_PART_IN_STOCK_TAB,
  IFSAPP.SHOP_DTS_INFO,
  IFSAPP.PRODUCT_CATEGORY_INFO
WHERE 
  IFSAPP.SHOP_DTS_INFO.SHOP_CODE=IFSAPP.INVENTORY_PART_IN_STOCK_TAB.CONTRACT AND 
  IFSAPP.INVENTORY_PART_IN_STOCK_TAB.PART_NO=IFSAPP.PRODUCT_CATEGORY_INFO.PRODUCT_CODE and 
  AREA_CODE like '&area_code' and 
  GROUP_NO like '&product_group'
group by AREA_CODE,GROUP_NO

union all


select 
    w.WARE_HOUSE_NAME as AREA_CODE,
    p.GROUP_NO,
    i.part_no,
    sum(QTY_ONHAND) as ONHAND 
from
  IFSAPP.INVENTORY_PART_IN_STOCK_TAB i,
  IFSAPP.WARE_HOUSE_INFO w,
  IFSAPP.PRODUCT_CATEGORY_INFO p
WHERE 
  w.ware_house_name = i.contract AND 
  i.part_no = p.product_code and 
  w.WARE_HOUSE_NAME like '&ware_house' and 
  p.GROUP_NO = '&product_group'
group by w.WARE_HOUSE_NAME, p.GROUP_NO, i.part_no
