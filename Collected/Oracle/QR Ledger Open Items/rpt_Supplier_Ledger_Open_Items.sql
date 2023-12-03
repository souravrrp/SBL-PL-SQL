select sv1.company_id,
    sv1.company_name,
    sv1.supplier_no,
    sv1.supplier_name,
    sv2.party_type,
    sv2.code_a,
    sv1.ledger_item_series_id,
    sv2.ledger_item_series_id,
    sv2.ledger_item_id,
    sv1.invoice_or_pp_date,
    sv1.pay_term_base_date,
    sv1.ledger_status,
    sv1.sup_inv_total,
    sv1.accounting_currency,
    sv1.installment_id,
    sv1.due_date,
    --soi.pl_pay_date,
    --soi.authorized,
    sv1.full_amount,
    sv1.sup_open_total,
    sv1.rest_amount

from

  (select soi.company_id,
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
      --soi.pl_pay_date,
      --soi.authorized,
      soi.full_amount,
      soi.sup_open_total,
      soi.rest_amount
  from SUP_OPEN_ITEM_RPT soi
  where --soi.supplier_no in ('E10018') and
    substr(soi.codestring, 1, instr(soi.codestring, '^') - 1) = '10100200' and
    soi.result_key = /*2772998*/ (select max(soin.result_key) from SUP_OPEN_ITEM_NAMES_RPT soin)) sv1

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
      li.party_type = 'SUPPLIER' and
      li.ROWSTATE IN ('Unpaid', 'PartlyPaid')) sv2

  on
    sv1.company_id = sv2.company and
    sv1.supplier_no = sv2.identity and
    sv1.ledger_item_series_id = (sv2.ledger_item_series_id || ' ' || sv2.ledger_item_id)
