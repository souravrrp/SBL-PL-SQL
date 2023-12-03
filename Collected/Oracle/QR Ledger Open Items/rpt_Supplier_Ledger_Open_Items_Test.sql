select soi.result_key,
    soi.company_id,
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
    soi.authorized,
    soi.full_amount,
    soi.sup_open_total,
    soi.rest_amount
from SUP_OPEN_ITEM_RPT soi
where --soi.supplier_no in ('E10018') and
  soi.result_key = /*2772998*/ (select max(soin.result_key) from SUP_OPEN_ITEM_NAMES_RPT soin)
