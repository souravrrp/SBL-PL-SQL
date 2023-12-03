--***** Customer Order Line Discount Summary
select extract(year from b.invoice_date) || '-' ||
       extract(month from b.invoice_date) "YEAR-PERIOD",
       /*b.c10 "SITE",*/
       d.discount_type,
       /*b.c5                PRODUCT_CODE,*/
       /*b.SALES_QUANTITY,*/
       /*sum(b.SALES_QUANTITY * d.calculation_basis) total_nsp,*/
       sum(b.SALES_QUANTITY * d.discount_amount) total_discount_amount /*,
       sum(b.net_curr_amount) SALES_PRICE,
       sum(b.vat_curr_amount) VAT*/
  from ifsapp.CUST_ORDER_LINE_DISCOUNT_TAB d
 inner join (select c.*,
                    t.c1,
                    t.c2,
                    t.c3,
                    t.c5,
                    t.c10,
                    case
                      when t.net_curr_amount != 0 then
                       t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                      else
                       IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                          t.item_id,
                                                          T.N2) --t.n2
                    end SALES_QUANTITY,
                    t.net_curr_amount,
                    t.vat_curr_amount,
                    i.invoice_date
               from ifsapp.CUST_INVOICE_ITEM_DISCOUNT c
              inner join ifsapp.INVOICE_ITEM t
                 on c.invoice_id = t.invoice_id
                and c.item_id = t.item_id
              inner join ifsapp.INVOICE_TAB i
                 on t.invoice_id = i.invoice_id
              where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                and t.state = 'Posted'
                and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
                    ('INV', 'PKG' /*, 'KOMP'*/)) b
    on d.order_no = b.c1
   and d.line_no = b.c2
   and d.rel_no = b.c3
   and d.discount_line_no = b.discount_line_no
 where b.invoice_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
      /*and d.order_no like 'WSM-R%'*/
   AND D.ORDER_NO not in (select r.ORDER_NO
                            from ifsapp.HPNRET_CUSTOMER_ORDER_TAB r
                           where r.ORDER_NO = D.ORDER_NO
                             and r.CASH_CONV = 'TRUE')
 group by /*b.c10,*/ extract(year from b.invoice_date) || '-' ||
          extract(month from b.invoice_date),
          d.discount_type
 order by /*b.c10,*/ extract(year from b.invoice_date) || '-' ||
          extract(month from b.invoice_date),
          d.discount_type
