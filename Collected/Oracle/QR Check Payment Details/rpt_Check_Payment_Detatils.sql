select to_char(t.payment_date, 'YYYY/MM/DD') "Payment Date",
       t.identity "Customer ID",
       t.name "Customer Name",
       substr(t.ledger_item_id, 0, instr(t.ledger_item_id, '#') - 1) "Check No",
       /*'Check No# '||substr(t.ledger_item_id,0,instr(t.ledger_item_id, '#') - 1)||', '||*/
       t.voucher_text "Narration",
       t.voucher_no "Voucher No",
       to_char(t.fully_paid_voucher_date, 'YYYY/MM/DD') "Voucher Date",
       to_char(t.clear_date, 'YYYY/MM/DD') "Clear Date",
       t.full_curr_amount "Amount",
       t.cash_account "Bank Account ID",
       t.state "Status"
  from CHECK_LEDGER_ITEM t
 where t.identity like '&CustomerID'
   and t.payment_date between to_date('&FromDate', 'YYYY/MM/DD') and
       to_date('&ToDate', 'YYYY/MM/DD')
 order by t.payment_date, t.voucher_no;
