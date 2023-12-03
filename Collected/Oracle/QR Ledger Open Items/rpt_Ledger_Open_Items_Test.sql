select soi.company_id,
    soi.company_name,
    soi.supplier_no,
    soi.supplier_name,
    substr(soi.codestring, 1, instr(soi.codestring, '^') - 1) CODE_A,
    soi.ledger_item_series_id,
    soi.invoice_or_pp_date,
    soi.pay_term_base_date,
    soi.ledger_status,
    soi.sup_inv_total,
    soi.accounting_currency,
    soi.installment_id,
    soi.due_date,
    soi.pl_pay_date,
    soi.full_amount,
    soi.sup_open_total,
    soi.rest_amount
from SUP_OPEN_ITEM_RPT soi
where soi.supplier_no in ('E 10670', 'E 10671') and
  soi.result_key = /*2743047*/ (select max(soin.result_key) from SUP_OPEN_ITEM_NAMES_RPT soin)

union

select coi.company_id,
    coi.company_name,
    coi.customer_no,
    coi.customer_name,
    --coi.codestring,
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
    coi.rest_amount
    --coi.balance_until_date,
    --coi.balance_dom_until_date
from CUST_OPEN_ITEM_RPT coi
where --coi.customer_no in ('E10001', 'E10012', 'E10018') and
  coi.result_key = (select max(coin.result_key) from CUST_OPEN_ITEM_NAMES_RPT coin)
