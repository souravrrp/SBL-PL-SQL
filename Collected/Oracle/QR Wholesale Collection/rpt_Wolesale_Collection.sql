--Check Collections of Dealers
select t.identity dealer_ID,
       t.name     dealer_name,
       /*t.ledger_item_series_id,
       t.ledger_item_id,
       t.ledger_item_version,*/
       to_char(t.payment_date, 'YYYY/MM/DD') payment_date,
       t.full_curr_amount pay_amount,
       t.voucher_text narration,
       t.way_id,
       nvl(substr(t.ledger_item_id, 0, instr(t.ledger_item_id, '#') - 1),
           t.ledger_item_id) check_no,
       to_char(t.clear_date, 'YYYY/MM/DD') clear_date,
       t.cash_account bank_ID,
       t.payment_id,
       t.voucher_type,
       t.voucher_no,
       to_char(t.voucher_date, 'YYYY/MM/DD') voucher_date,
       t.state status
  from ifsapp.CHECK_LEDGER_ITEM t
 where t.identity like '&dealer_id'
   and t.way_id = 'CHECK'
   and t.party_type = 'Customer'
   and t.state != 'Cancelled'
   and t.payment_date between to_date('&FromDate', 'YYYY/MM/DD') and
       to_date('&ToDate', 'YYYY/MM/DD')
   and t.cash_account like '&bank_id'
   and t.full_curr_amount like '&amount'

union all

--Cash Collections of Dealers
select l.identity dealer_id,
       ifsapp.customer_info_api.Get_Name(l.identity) dealer_name,
       to_char(m.mixed_payment_date, 'YYYY/MM/DD') payment_date,
       l.curr_amount pay_amount,
       l.text narration,
       'CASH' way_id,
       '' check_no,
       '' clear_date,
       m.short_name bank_ID,
       m.mixed_payment_id payment_id,
       m.voucher_type_ref voucher_type,
       m.voucher_no_ref voucher_no,
       to_char(m.voucher_date_ref, 'YYYY/MM/DD') voucher_date,
       m.rowstate status
  from ifsapp.MIXED_PAYMENT_LUMP_SUM_TAB l
 inner join ifsapp.MIXED_PAYMENT_TAB m
    on m.mixed_payment_id = l.mixed_payment_id
 where l.identity like '&dealer_id'
   and l.party_type = 'CUSTOMER'
   and m.rowstate != 'Cancelled'
   and m.mixed_payment_date between to_date('&FromDate', 'YYYY/MM/DD') and
       to_date('&ToDate', 'YYYY/MM/DD')
   and m.short_name like '&bank_id'
   and l.curr_amount like '&amount'
 order by 3
