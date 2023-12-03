--***** Wholesale Invoice Aging Details As on Date JP
select o.dealer_id,
       o.dealer_name,
       o.series_id,
       o.invoice_no,
       o.invoice_date,
       o.due_date,
       o.inv_amount,
       o.open_amount,
       ( $P{AS_ON_DATE}  - trunc(o.invoice_date) + 1) age,
       case
         when ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) <= 30 then
          '000 - 030'
         when ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) > 30 and
              ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) <= 60 then
          '031 - 060'
         when ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) > 60 and
              ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) <= 90 then
          '061 - 090'
         when ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) > 90 and
              ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) <= 120 then
          '091 - 120'
         when ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) > 120 and
              ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) <= 150 then
          '121 - 150'
         when ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) > 150 and
              ($P{AS_ON_DATE} - trunc(o.invoice_date) + 1) <= 180 then
          '151 - 180'
         else
          '180+'
       end band,
       o.pay_term_id,
       o.phone_no,
       o.dealer_address
  from IFSAPP.SBL_VW_WS_DEALER_OPEN_INVOICE o
 where o.dealer_id like $P{DEALER_ID}
 order by o.invoice_id
