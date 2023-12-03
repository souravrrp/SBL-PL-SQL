--HP Partial Sales for Stand
select (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = d.contract) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = d.contract) district_code,
       d.contract,
       d.account_no,
       d.line_no,
       d.catalog_no,
       d.quantity,
       trunc(d.sales_date) sales_date,
       H.ROWSTATE head_state,
       d.rowstate
  from HPNRET_HP_HEAD_TAB h
 inner join HPNRET_HP_DTL_TAB d
    on h.account_no = d.account_no
 where h.rowstate = 'PartiallyActive'
   and d.rowstate = 'Released'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(d.catalog_no) in
       ('INV', 'PKG')
   and trunc(d.sales_date) /*<= to_date('&As_On_Date', 'YYYY/MM/DD')*/
                           between to_date('&FROM_DATE', 'YYYY/MM/DD') and to_date('&TO_DATE', 'YYYY/MM/DD')
   and d.catalog_no /*not in ('SRST-010',
                            'SRST-014',
                            'SRST-015',
                            'SRST-020',
                            'PG-BT-TV-WALL-BRACKET') like 'SRST-%'*/ /*=*/
       /*'GPROU-3G-POCKET-ROUTER'*/ /*'SRGFT-SURF-EXCEL-2018'*/ /*'NSWR-WIRELESS-ROUTER'*/ in ('SRRC-SRCFN1020JLRC',
                                                                                          'SRCKW-MULTIPAN-ALU-26',
                                                                                          'SRPAN-SINGER-RUTI-TAWA')

union

--Cash Partial Sales for Stand
select (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = l.contract) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = l.contract) district_code,
       l.contract,
       l.order_no,
       l.line_no,
       l.catalog_no,
       l.buy_qty_due,
       trunc(l.date_entered) sales_date,
       C.Rowstate head_state,
       l.rowstate
  from CUSTOMER_ORDER_TAB c
 inner join CUSTOMER_ORDER_LINE_TAB l
    on c.order_no = l.order_no
 where c.rowstate = 'PartiallyDelivered'
   and l.rowstate = 'Released'
   and c.internal_po_no is null
   and substr(c.order_no, 4, 2) = '-R'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(l.catalog_no) in
       ('INV', 'PKG')
   and trunc(l.date_entered) /*<= to_date('&As_On_Date', 'YYYY/MM/DD')*/
                             between to_date('&FROM_DATE', 'YYYY/MM/DD') and to_date('&TO_DATE', 'YYYY/MM/DD')
   and l.catalog_no /*not in ('SRST-010',
                            'SRST-014',
                            'SRST-015',
                            'SRST-020',
                            'PG-BT-TV-WALL-BRACKET') like 'SRST-%'*/ /*=*/
       /*'GPROU-3G-POCKET-ROUTER'*/ /*'SRGFT-SURF-EXCEL-2018'*/ /*'NSWR-WIRELESS-ROUTER'*/ in ('SRRC-SRCFN1020JLRC',
                                                                                          'SRCKW-MULTIPAN-ALU-26',
                                                                                          'SRPAN-SINGER-RUTI-TAWA')
 order by /*1,2,3,*/ 8
