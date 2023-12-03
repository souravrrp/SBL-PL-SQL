select li.company,
    (select c.name from COMPANY_TAB c where c.company = li.company) company_name,
    li.identity party_id,
    (SELECT sui.name FROM SUPPLIER_INFO_TAB sui where sui.supplier_id = li.identity) party_name,
    li.party_type,
    li.code_a,
    li.ledger_item_series_id || ' ' || li.ledger_item_id invoice_pp_id,
    to_char((select I.INVOICE_DATE FROM INVOICE_TAB I where i.invoice_id = li.invoice_id), 'YYYY/MM/DD') invoice_or_pp_date,
    to_char((SELECT I.PAY_TERM_BASE_DATE FROM INVOICE_TAB I where i.invoice_id = li.invoice_id), 'YYYY/MM/DD') pay_term_base_date,
    --LI.ROWTYPE,
    --li.ledger_item_series_id,
    --li.ledger_item_id,
    li.status_id ledger_status,
    li.full_dom_amount invoice_amount,    
    li.currency,
    --li.curr_rate,
    to_char((SELECT I.Due_Date FROM INVOICE_TAB I where i.invoice_id = li.invoice_id), 'YYYY/MM/DD') due_date,
    li.full_curr_amount installment_amount,
    (li.full_curr_amount - li.cleared_curr_amount) open_amount,
    (li.full_curr_amount - li.cleared_curr_amount) open_amount_in_curr_acc
    --li.invoice_id,
    /*(select p.due_date 
      from PAYMENT_PLAN_TAB p 
      where p.company = li.company and 
        p.identity = li.identity and 
        p.party_type = li.party_type and 
        p.invoice_id = li.invoice_id and 
        p.installment_id = 1) due2_date,*/ 
from LEDGER_ITEM_TAB li
where li.code_a like '&account_no' and
  li.identity like '&employee_id' and
  li.invoice_id in (select i.invoice_id FROM INVOICE_TAB I where i.invoice_id = li.invoice_id and i.invoice_date <= to_date('&to_date', 'YYYY/MM/DD')) and
  --li.identity in ('&party_id') and
  --li.ledger_item_series_id = 'EMPADV' and
  --LI.ROWTYPE != 'InvoiceLedgerItem' AND
  li.rowstate in ('Unpaid', 'PartlyPaid')
  order by li.identity

--Fresh one
select li.company,
    (select c.name from COMPANY_TAB c where c.company = li.company) company_name,
    li.identity customer_id,
    (SELECT sui.name FROM SUPPLIER_INFO_TAB sui where sui.supplier_id = li.identity) customer_name,
    li.party_type customer_type,
    li.code_a,
    li.ledger_item_series_id || ' ' || li.ledger_item_id invoice_pp_id,
    to_char((select I.INVOICE_DATE FROM INVOICE_TAB I where i.invoice_id = li.invoice_id), 'YYYY/MM/DD') invoice_or_pp_date,
    to_char((SELECT I.PAY_TERM_BASE_DATE FROM INVOICE_TAB I where i.invoice_id = li.invoice_id), 'YYYY/MM/DD') pay_term_base_date,
    li.status_id ledger_status,
    li.full_dom_amount invoice_amount,    
    li.currency,
    to_char((SELECT I.Due_Date FROM INVOICE_TAB I where i.invoice_id = li.invoice_id), 'YYYY/MM/DD') due_date,
    li.full_curr_amount installment_amount,
    (li.full_curr_amount - li.cleared_curr_amount) open_amount,
    (li.full_curr_amount - li.cleared_curr_amount) open_amount_in_curr_acc
from LEDGER_ITEM_TAB li
where li.code_a like '&account_no' and
  li.identity like '&employee_id' and
  li.invoice_id in (select i.invoice_id FROM INVOICE_TAB I where i.invoice_id = li.invoice_id and i.invoice_date <= to_date('&to_date', 'YYYY/MM/DD')) and
  li.rowstate in ('Unpaid', 'PartlyPaid')
  order by li.identity


