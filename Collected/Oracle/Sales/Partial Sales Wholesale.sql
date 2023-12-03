--WS Partial Sales
select l.contract,
       l.order_no,
       l.line_no,
       l.customer_no,
       ifsapp.customer_info_api.Get_Name(l.CUSTOMER_NO) CUSTOMER_NAME,
       l.catalog_no,
       l.buy_qty_due,
       l.qty_invoiced,
       (l.buy_qty_due - l.qty_invoiced) qty_not_delivered,
       trunc(l.date_entered) sales_date,
       C.Rowstate head_state,
       l.rowstate
  from IFSAPP.CUSTOMER_ORDER_TAB c
 inner join IFSAPP.CUSTOMER_ORDER_LINE_TAB l
    on c.order_no = l.order_no
 where c.rowstate in
       ('PartiallyDelivered', 'Invoiced', 'Delivered', 'Cancelled')
   and l.rowstate in ('Cancelled', 'Released', 'PartiallyDelivered')
   and c.internal_po_no is null
   and substr(c.order_no, 4, 2) = '-R'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(l.catalog_no) in
       ('INV', 'PKG')
   and trunc(l.date_entered) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and l.contract in ('JWSS', 'SAOS', 'SWSS', 'WSMO')
/*and l.catalog_no \*not in ('SRST-010',
                     'SRST-014',
                     'SRST-015',
                     'SRST-020',
                     'PG-BT-TV-WALL-BRACKET') like 'SRST-%'*\ =
\*'GPROU-3G-POCKET-ROUTER'*\ \*'SRGFT-SURF-EXCEL-2018'*\ 'SRRC-SRCFN1050JLRC'*/
 order by /*1,2,3,*/ 8
