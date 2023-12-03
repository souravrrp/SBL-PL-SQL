select t.*, i.invoice_date, i.rowstate
  from INVOICE_ITEM_TAB t
 inner join INVOICE_TAB i
    on t.invoice_id = i.invoice_id
 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = /*'Prepared'*/
       'Unposted'
   and i.invoice_date between to_date('2019/2/1', 'YYYY/MM/DD') and
       to_date('2019/2/28', 'YYYY/MM/DD')
