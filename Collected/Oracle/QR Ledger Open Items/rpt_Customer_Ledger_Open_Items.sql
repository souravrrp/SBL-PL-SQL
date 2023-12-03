select cv1.company_id,
    cv1.company_name,
    cv1.customer_no,
    cv1.customer_name,
    cv2.party_type,
    cv2.code_a,
    cv1.ledger_item_series_id,
    cv2.ledger_item_series_id,
    cv2.ledger_item_id,
    cv1.invoice_or_pp_date,
    cv1.pay_term_base_date,
    cv1.ledger_status,
    cv1.cust_inv_total,
    cv1.accounting_currency,
    cv1.installment_id,
    cv1.due_date,
    cv1.full_amount,
    cv1.cust_open_total,
    --cv2."Open Amount",
    cv1.rest_amount--,

from
  (select coi.company_id,
      coi.company_name,
      coi.customer_no,
      coi.customer_name,
      substr(coi.codestring,1,instr(coi.codestring, '^') - 1) CODE_A,
      coi.ledger_item_series_id,
      coi.invoice_or_pp_date,
      coi.pay_term_base_date,
      coi.ledger_status,
      coi.cust_inv_total,
      coi.accounting_currency,
      coi.installment_id,
      coi.due_date,
      coi.current_due_date,
      coi.full_amount,
      coi.cust_open_total,
      coi.rest_amount,
      coi.balance_until_date,
      coi.balance_dom_until_date
  from CUST_OPEN_ITEM_RPT coi
  where --coi.customer_no in ('E20129') and
    substr(coi.codestring,1,instr(coi.codestring, '^') - 1) = '10100200' and
    coi.result_key = (select max(coin.result_key) from CUST_OPEN_ITEM_NAMES_RPT coin)) cv1
    
  left outer join

  (select li.company,
    li.identity,
    li.party_type,
    li.ledger_item_series_id,
    li.ledger_item_id,
    li.ledger_item_series_id || ' ' || li.ledger_item_id,
    li.full_curr_amount,
    li.cleared_curr_amount,
    li.full_curr_amount - li.cleared_curr_amount "Open Amount",
    li.currency,
    li.curr_rate,
    li.status_id,
    li.code_a,
    li.rowstate
  from LEDGER_ITEM_TAB li
  WHERE --li.IDENTITY = 'E10018' AND
    li.CODE_A = '10100200' AND
    li.party_type = 'CUSTOMER' and
    li.ROWSTATE IN ('Unpaid', 'PartlyPaid')) cv2

  on
    cv1.company_id = cv2.company and
    cv1.customer_no = cv2.identity and
    cv1.ledger_item_series_id = (cv2.ledger_item_series_id ||' '|| cv2.ledger_item_id)
