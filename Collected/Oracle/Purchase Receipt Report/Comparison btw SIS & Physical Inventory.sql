select v1.contract,
v1.part_no,
nvl(v1.SIS_qty_recived, 0) SIS_qty_recived,
nvl(v2.PI_qty_received, 0) PI_qty_received
from 
  (select t.contract,
      t.part_no,    
      sum(t.qty_arrived) SIS_qty_recived
  from PURCHASE_RECEIPT_NEW t
  where t.arrival_date between to_date('&fromDate', 'YYYY/MM/DD') and to_date('&toDate', 'YYYY/MM/DD') and
    t.state = 'Received' and
    t.contract not in ('DITF', 'BSCP', 'CSCP', 'DSCP', 'JSCP', 'SSCP')
  group by t.contract, t.part_no
  order by t.contract, t.part_no) v1 --SIS Status

left join

  (select rc.shop_code,
      rc.product_code,    
      sum(rc.quantity) PI_qty_received
  from REC_AFTER_CUT_OFF_TBL rc
  group by rc.shop_code, rc.product_code
  order by rc.shop_code, rc.product_code) v2 --Physical Inventory Status
on
  v1.contract = v2.shop_code and
  v1.part_no = v2.product_code --and
  --v1.contract not in ('DITF', 'BSCP', 'CSCP', 'JSCP', 'SSCP')
order by v1.contract, v1.part_no
