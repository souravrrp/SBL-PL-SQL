--***** Wholesale Invoice Aging Details Month End
insert into
select '&YEAR' "YEAR",
       '&PERIOD' PERIOD,
       o.identity dealer_id,
       ifsapp.customer_info_api.Get_Name(o.identity) dealer_name,
       o.ledger_item_series_id series_id,
       o.ledger_item_id invoice_no,
       o.invoice_id,
       o.voucher_type,
       o.voucher_no,
       o.ledger_date invoice_date,
       o.due_date,
       o.pay_term_base_date,
       o.inv_amount,
       o.open_amount,
       (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) age,
       case
         when (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) <= 30 then
          '000 - 030'
         when (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) > 30 and
              (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) <= 60 then
          '031 - 060'
         when (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) > 60 and
              (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) <= 90 then
          '061 - 090'
         when (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) > 90 and
              (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) <= 120 then
          '091 - 120'
         when (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) > 120 and
              (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) <= 150 then
          '121 - 150'
         when (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) > 150 and
              (last_day(to_date('&YEAR'||'/'||'&PERIOD'||'/1', 'YYYY/MM/DD')) - trunc(o.ledger_date) + 1) <= 180 then
          '151 - 180'
         else
          '180+'
       end band,
       (select i.pay_term_id
          from IFSAPP.INVOICE_TAB i
         where i.invoice_id = o.invoice_id) pay_term_id,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(o.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(o.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(o.identity, 1) dealer_address
  from IFSAPP.LEDGER_ITEM_CU_DET_QRY o
 where (o.identity like 'W000%' or o.identity like 'IT000%' or o.identity like 'S000%')
   and o.open_amount > 0
 order by o.invoice_id;
 COMMIT;
