select * from SBL_INVENTORY_COUNTING_DTS t

select t.catalog_no,
    t.site,
    nvl(t.qty_onhand, 0) qty_onhand,
    nvl(t.qty_saleable, 0) qty_saleable,
    nvl(T.QTY_REVERT, 0) QTY_REVERT,
    nvl(T.QTY_BER, 0) QTY_BER,
    nvl((select sum(sl.quantity) qty_sold 
      from SBL_SALES_TEMP_FOR_INVENTORY sl
      where sl.product_code = t.catalog_no and sl.shop_code = t.site), 0) qty_sold,
    nvl((select sum(se.quantity) qty_sent 
      from SBL_SEND_TEMP_FOR_INVENTORY se
      where se.product_code = t.catalog_no and se.shop_code = t.site), 0) qty_sent,
    nvl((select sum(rc.quantity) quantity 
      from REC_AFTER_CUT_OFF_TBL rc
      where rc.product_code = t.catalog_no and rc.shop_code = t.site), 0) qty_received
    --(t.qty_onhand + qty_received) - (qty_saleable + QTY_REVERT + QTY_BER + qty_sold + qty_sent)) qty_short_over
from SBL_INVENTORY_COUNTING_DTS t
where t.catalog_no in ('SGST-005', 'SGST-006', 'SRST-008', 'SRST-009', 'SRST-010', 'SRST-013', 'SRST-014', 'SRST-015', 'SRST-016', 
'SRST-001', 'SRST-002', 'SRST-003', 'SRST-004', 'SRST-007', 'SRST-017', 'HRST-011')
order by t.site


--Product code wise no. of stands sold in each shop
select sl.product_code,
    sl.shop_code, 
    --sl.quantity     
    sum(sl.quantity) qty_sold 
from SBL_SALES_TEMP_FOR_INVENTORY sl
where sl.product_code in ('SGST-005', 'SGST-006', 'SRST-008', 'SRST-009', 'SRST-010', 'SRST-013', 'SRST-014', 'SRST-015', 'SRST-016', 
'SRST-001', 'SRST-002', 'SRST-003', 'SRST-004', 'SRST-007', 'SRST-017', 'HRST-011')
group by sl.shop_code, sl.product_code
order by sl.shop_code


--Product code wise no. of stands sent in each shop
select se.product_code, 
    se.shop_code,
    --se.quantity 
    sum(se.quantity) qty_sent 
from SBL_SEND_TEMP_FOR_INVENTORY se
where se.product_code in ('SGST-005', 'SGST-006', 'SRST-008', 'SRST-009', 'SRST-010', 'SRST-013', 'SRST-014', 'SRST-015', 'SRST-016', 
'SRST-001', 'SRST-002', 'SRST-003', 'SRST-004', 'SRST-007', 'SRST-017', 'HRST-011')
group by se.shop_code, se.product_code
order by se.shop_code

--Product code wise no. of stands received in each shop
select rc.product_code,
    rc.shop_code,
    sum(rc.quantity) quantity 
from REC_AFTER_CUT_OFF_TBL rc
where 
  rc.product_code in ('SGST-005', 'SGST-006', 'SRST-008', 'SRST-009', 'SRST-010', 'SRST-013', 'SRST-014', 'SRST-015', 'SRST-016', 
  'SRST-001', 'SRST-002', 'SRST-003', 'SRST-004', 'SRST-007', 'SRST-017', 'HRST-011') --and
  --rc.shop_code = 'SWHW'
group by rc.shop_code, rc.product_code
order by rc.shop_code
