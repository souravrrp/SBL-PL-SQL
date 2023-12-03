select t.contract,
       t.vendor_no,
       /*t.part_no,
       t.description,*/
       sum(t.qty_arrived) qty_arrived,
       t.state
  from PURCHASE_RECEIPT_NEW t
 where t.arrival_date between to_date('&fromDate', 'YYYY/MM/DD') and
       to_date('&toDate', 'YYYY/MM/DD')
   and t.state != 'Cancelled' /*'Received' */
   and t.contract = 'CTGW'
   and t.part_no like 'SRWM-%'   
   and t.vendor_no in
       ('XFCH-ZGCE', 'XFCH-HNWM', 'XFSP-MIDEA', 'XFCH-NDNE', 'XFCH-NXHA')
 group by t.contract, /*t.part_no, T.description,*/ t.vendor_no, t.state
 /*order by t.part_no*/
