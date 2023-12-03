--*****Shopwise as on inventory/stock report for a product group
select 
  i.contract,
  i.PART_NO,
  sum(i.QTY_ONHAND) as ONHAND 
from
  IFSAPP.INVENTORY_PART_IN_STOCK_TAB i,
  IFSAPP.PRODUCT_CATEGORY_INFO p
WHERE 
  i.part_no = p.product_code and 
  p.GROUP_NO = 131 and --131 Safe
  --*** All Shops
  i.Contract not in ('BBWH', 'BWHW', 'KWHW', 'RWHW', 'TWHW', 'CMWH', 'SPWH', 'SWHW', 'CTGW', 'APWH', 'SYWH', 'MYWH', 
    'BSCP', 'CSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC', 
    'WSMO', 'SWSS', 'SAOS', 'JWSS', 'SCSM', 'SAPM', 'SESM')
group by i.contract, i.PART_NO
order by i.contract, i.PART_NO


--*****Shopwise as on inventory/stock report for a particular product brand or part no.
select 
  --(select to_number(s.district_code) from IFSAPP.SHOP_DTS_INFO s where s.shop_code = i.contract) district_code,
  i.contract,
  i.PART_NO,
  sum(i.QTY_ONHAND) as ONHAND 
from
  IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
WHERE 
  i.PART_NO like 'SC%' and --'GJREF%'
  --*** All Shops
  i.Contract not in ('BBWH', 'BWHW', 'KWHW', 'RWHW', 'TWHW', 'CMWH', 'SPWH', 'SWHW', 'CTGW', 'APWH', 'SYWH', 'MYWH', 
    'BSCP', 'CSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC', 
    'WSMO', 'SWSS', 'SAOS', 'JWSS', 'SCSM', 'SAPM', 'SESM')
group by i.contract, i.PART_NO
--order by district_code, i.contract, i.PART_NO

union

select 
  i.contract,
  i.PART_NO,
  sum(i.QTY_ONHAND) as ONHAND 
from
  IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
WHERE 
  i.PART_NO like 'MX%' and
  --*** All Shops
  i.Contract not in ('BBWH', 'BWHW', 'KWHW', 'RWHW', 'TWHW', 'CMWH', 'SPWH', 'SWHW', 'CTGW', 'APWH', 'SYWH', 'MYWH', 
    'BSCP', 'CSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC', 
    'WSMO', 'SWSS', 'SAOS', 'JWSS', 'SCSM', 'SAPM', 'SESM')
group by i.contract, i.PART_NO
order by contract, PART_NO
