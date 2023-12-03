--Trip List with PO info
select tl.trip_no,
       tl.release_no,
       tl.order_no internal_co_no,
       tl.line_no,
       tl.rel_no,
       tl.debit_note_no,
       tl.invoice_no,
       tl.vat_receipt_no,
       trunc(c.real_ship_date) real_ship_date,
       c.demand_order_ref1,
       c.demand_order_ref2,
       c.demand_order_ref3,
       c.demand_order_ref4,
       c.demand_code
  from IFSAPP.TRN_TRIP_PLAN_CO_LINE_TAB tl
 inner join IFSAPP.CUSTOMER_ORDER_LINE_TAB c
    on tl.order_no = c.order_no
   and tl.line_no = c.line_no
   and tl.rel_no = c.rel_no
   and tl.line_item_no = c.line_item_no
 where c.demand_code = 'IPD'
   /*and trunc(c.real_ship_date) between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')*/
   AND TL.TRIP_NO = 135226
