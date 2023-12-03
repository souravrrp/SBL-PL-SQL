create or replace view SBL_VW_RPT_BANK_ACCT_DTL as
select p.proposal_id,
       i.item_id,
       p.date_from,
       p.date_to,
       i.payment_date,
       p.contract,
       p.proposal_no,
       p.way_id,
       p.short_name ACCOUNT_NO,
       IFSAPP.CASH_ACCOUNT_API.Get_Account_Identity(p.company, p.short_name) ACCOUNT_NO_DT,
       IFSAPP.CASH_ACCOUNT_API.Get_Description(p.company, p.short_name) ACCOUNT_NAME,
       i.full_curr_amount AMOUNT,
       i.ledger_item_id,
       substr(i.ledger_item_id, 0, instr(i.ledger_item_id, '#') - 1) DDNO,
       substr(i.ledger_item_id, instr(i.ledger_item_id, '#') + 1, 11) DD_DATE,
       i.ledger_item_series_id,
       i.identity,
       i.party_type,
       g.voucher_type,
       g.voucher_no,
       g.row_no,
       g.voucher_date,
       g.accounting_year,
       g.accounting_period,
       g.account_desc,
       g.code_b,
       g.code_b_desc,
       g.trans_code,
       g.debet_amount,
       g.credit_amount,
       g.party_type_id,
       g.reference_serie,
       g.reference_number,
       g.text
  from IFSAPP.CHECK_CASH_PROPOSAL_ITEM i,
       IFSAPP.CHECK_CASH_PROPOSAL      p,
       IFSAPP.GEN_LED_VOUCHER_ROW      g
 where i.proposal_id = p.proposal_id
   and g.reference_serie = i.ledger_item_series_id
   and g.reference_number = i.ledger_item_id
   and g.party_type_id = i.identity
 order by i.proposal_id, i.item_id;
