--***** Wholesale Computer Sales Invoice Aging Details JP
select o.dealer_id,
       o.dealer_name,
       o.series_id,
       o.invoice_no,
       o.invoice_date,
       o.due_date,
       o.inv_amount,
       o.open_amount,
       (trunc(sysdate) - trunc(o.invoice_date) + 1) age,
       case
         when (trunc(sysdate) - trunc(o.invoice_date) + 1) <= 30 then
          '000 - 030'
         when (trunc(sysdate) - trunc(o.invoice_date) + 1) > 30 and
              (trunc(sysdate) - trunc(o.invoice_date) + 1) <= 60 then
          '031 - 060'
         when (trunc(sysdate) - trunc(o.invoice_date) + 1) > 60 and
              (trunc(sysdate) - trunc(o.invoice_date) + 1) <= 90 then
          '061 - 090'
         when (trunc(sysdate) - trunc(o.invoice_date) + 1) > 90 and
              (trunc(sysdate) - trunc(o.invoice_date) + 1) <= 120 then
          '091 - 120'
         when (trunc(sysdate) - trunc(o.invoice_date) + 1) > 120 and
              (trunc(sysdate) - trunc(o.invoice_date) + 1) <= 150 then
          '121 - 150'
         when (trunc(sysdate) - trunc(o.invoice_date) + 1) > 150 and
              (trunc(sysdate) - trunc(o.invoice_date) + 1) <= 180 then
          '151 - 180'
         else
          '180+'
       end band,
       o.pay_term_id,
       o.phone_no,
       o.dealer_address
  from IFSAPP.SBL_VW_WS_DEALER_OPEN_INVOICE o
 inner join (select s.invoice_id
               from (select *
                       from IFSAPP.SBL_JR_SALES_DTL_INV i
                     union all
                     select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
              inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
                 on s.product_code = p.product_code
              where s.sales_price != 0
                and p.product_family in
                    ('COMPUTER-DESKTOP', 'COMPUTER-LAPTOP')
                and s.site in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM')
              group by s.invoice_id) c
    on o.invoice_id = c.invoice_id
 where o.dealer_id like $P{DEALER_ID}
 order by o.invoice_id
