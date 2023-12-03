--Sales & Cost for Comparison in a Specific Period
select /*ns.YEAR,
       ns.PERIOD,*/
       /*ns.SITE,*/
       ns.PRODUCT_CODE,
       /*sum(ns.SALES_QUANTITY) total_quantity,*/
       sum(ns.SALES_PRICE) total_sales_price,
       /*b.cost,*/
       round(sum(ns.SALES_QUANTITY * b.cost), 2) total_cost
  from (select extract(year from i.invoice_date) "YEAR",
               extract(month from i.invoice_date) PERIOD,
               t.c10 "SITE",
               t.c5 PRODUCT_CODE,
               sum(case
                     when t.net_curr_amount != 0 then
                      t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                     else
                      IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                         t.item_id,
                                                         T.N2)
                   end) SALES_QUANTITY,
               sum(t.net_curr_amount) SALES_PRICE
          from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
         where t.invoice_id = i.invoice_id
           and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           and t.rowstate = 'Posted'
              --and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV' --in ('INV', 'PKG')
           and t.c5 in ('SRREF-DF2-18',
                        'SRREF-G-BCD-192',
                        'SRREF-SINGER-DD2-29-BG',
                        'SRREF-RD-25DC',
                        'SRREF-SINGER-RD-34DR')
           and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
               to_date('&to_date', 'yyyy/mm/dd')
         group by extract(year from i.invoice_date),
                  extract(month from i.invoice_date),
                  t.c10,
                  t.c5) ns
 inner join IFSAPP.INVENT_ONLINE_COST_TAB b
    on ns.YEAR = b.year
   and ns.PERIOD = b.period
   and ns.SITE = b.contract
   and ns.PRODUCT_CODE = b.part_no
 group by /*ns.YEAR, ns.PERIOD,*/ ns.PRODUCT_CODE
 order by 1/*, 2, 3*/
