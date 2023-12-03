--*****Check Items
select to_char(t.payment_date, 'YYYY/MM/DD') "Transaction Date",
       --to_char(t.fully_paid_voucher_date,'YYYY/MM/DD') "Voucher Date",
       t.identity         "Customer ID",
       t.name             "Customer Name",
       t.full_curr_amount "Amount",
       /*'Check No# '||substr(t.ledger_item_id,0,instr(t.ledger_item_id, '#') - 1)||', '||*/
       t.voucher_text "Narration",
       t.cash_account "Bank ID",
       t.voucher_no "Voucher No",
       substr(t.ledger_item_id, 0, instr(t.ledger_item_id, '#') - 1) "Check No",
       to_char(t.clear_date, 'YYYY/MM/DD') "Clear Date",
       t.state "Status"
  from ifsapp.CHECK_LEDGER_ITEM t
 where t.payment_date between to_date('&FromDate', 'YYYY/MM/DD') and
       to_date('&ToDate', 'YYYY/MM/DD')
   and t.cash_account like '&BankID'
   and t.identity like '&CustomerID'
   and t.state != 'Cancelled'
   and t.full_curr_amount like '&Amount'

union

--*****Cash Items
select to_char(m.lump_sum_trans_date, 'YYYY/MM/DD') "Transaction Date",
       m.payer_identity "Customer ID",
       ifsapp.customer_info_api.Get_Name(m.payer_identity) "Customer Name",
       m.curr_amount "Amount",
       m.text "Narration",
       ifsapp.mixed_payment_api.Get_Short_Name(m.company,
                                               m.mixed_payment_id) "Bank ID",
       ifsapp.mixed_payment_api.Get_Voucher_No_Ref(m.company,
                                                   m.mixed_payment_id) "Voucher No",
       '' "Check No",
       '' "Clear Date",
       '' "Status"
  from ifsapp.mixed_payment_lump_sum_tab m
 where m.lump_sum_trans_date between to_date('&FromDate', 'YYYY/MM/DD') and
       to_date('&ToDate', 'YYYY/MM/DD')
   and ifsapp.mixed_payment_api.Get_Short_Name(m.company,
                                               m.mixed_payment_id) like
       '&BankID'
   and m.payer_identity like '&CustomerID'
   and m.curr_amount like '&Amount'
 order by 2, 1
