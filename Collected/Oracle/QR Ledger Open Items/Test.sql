select v1.company_id,
    v1.company_name,
    v1.customer_no,
    v1.customer_name,
    v2.party_type,
    v2.code_a,
    --substr(v1.codestring,1,instr(coi.codestring, '^') - 1) CODE_A,
    v1.ledger_item_series_id,
    v1.invoice_or_pp_date,
    v1.pay_term_base_date,
    v1.ledger_status,
    v1.cust_inv_total,
    v1.accounting_currency,
    v1.installment_id,
    v1.due_date,
    v1.current_due_date,
    v1.full_amount,
    v1.cust_open_total,
    v1.rest_amount,
    v1.balance_until_date,
    v1.balance_dom_until_date
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
    where --coi.customer_no in ('E10018') and
      coi.result_key = /*2785191*/ (select max(coin.result_key) from CUST_OPEN_ITEM_NAMES_RPT coin)) V1,

    (select li.company,
      li.identity,
      li.party_type,
      li.ledger_item_series_id,
      li.ledger_item_id,
      li.ledger_item_series_id||' '||li.ledger_item_id,
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
      li.ROWSTATE IN ('Unpaid', 'PartlyPaid', 'Created', 'Returned', 'Cancelled', 'Created', 'Cashed', 'Returned', 'UnderRemitted', 'Voided', 'Paid')) V2

where V1.customer_no = v2.identity and
v1.ledger_item_series_id = (v2.ledger_item_series_id||' '||v2.ledger_item_id)
