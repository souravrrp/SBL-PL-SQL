select t.order_no,
       t.contract,
       t.part_no,
       t.description,
       t.vendor_no,
       t.qty_arrived,
       --t.arrival_date,
       to_char(t.arrival_date, 'YYYY-MM-DD') arrival_date,
       t.receiver,
       t.receive_case,
       t.grn_no,
       t.state
  from IFSAPP.PURCHASE_RECEIPT_NEW t
 where t.arrival_date between to_date('&fromDate', 'YYYY/MM/DD') and
       to_date('&toDate', 'YYYY/MM/DD')
   and t.state = 'Received'
   --and t.contract = 'CTGW'
   and t.part_no = 'SRAC-SAS12L70GMGA'
 order by t.part_no
