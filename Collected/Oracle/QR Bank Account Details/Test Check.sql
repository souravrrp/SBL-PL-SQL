--Proposal
select p.proposal_id,
       p.date_from,
       p.date_to,
       p.contract,
       p.proposal_no,
       p.short_name ACCOUNT_NO,
       IFSAPP.CASH_ACCOUNT_API.Get_Account_Identity(p.company, p.short_name) ACCOUNT_NO_DT,
       IFSAPP.CASH_ACCOUNT_API.Get_Description(p.company, p.short_name) ACCOUNT_NAME
  from IFSAPP.CHECK_CASH_PROPOSAL p
 where p.date_from >= to_date('&from_date', 'YYYY/MM/DD')
   and p.date_to <= to_date('&to_date', 'YYYY/MM/DD')
   and p.short_name = 'SCOMBAL02'
 order by p.proposal_id; /*, p.date_from, p.proposal_no*/

--Proposal Item
select i.proposal_id,
       i.item_id,
       i.payment_date,
       i.full_curr_amount,
       i.ledger_item_id,
       substr(i.ledger_item_id, 0, instr(i.ledger_item_id, '#') - 1) DDNO,
       substr(i.ledger_item_id, instr(i.ledger_item_id, '#') + 1, 11) DD_DATE
  from IFSAPP.CHECK_CASH_PROPOSAL_ITEM i
 where i.payment_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 order by i.proposal_id, i.item_id; /*, i.payment_date*/

--Proposal & Proposal Item
select p.proposal_id,
       i.item_id,
       p.date_from,
       p.date_to,
       i.payment_date,
       p.contract,
       p.proposal_no,
       p.short_name ACCOUNT_NO,
       IFSAPP.CASH_ACCOUNT_API.Get_Account_Identity(p.company, p.short_name) ACCOUNT_NO_DT,
       IFSAPP.CASH_ACCOUNT_API.Get_Description(p.company, p.short_name) ACCOUNT_NAME,
       i.full_curr_amount,
       i.ledger_item_id,
       substr(i.ledger_item_id, 0, instr(i.ledger_item_id, '#') - 1) DDNO,
       substr(i.ledger_item_id, instr(i.ledger_item_id, '#') + 1, 11) DD_DATE,
       i.ledger_item_series_id,
       i.identity
  from IFSAPP.CHECK_CASH_PROPOSAL_ITEM i, IFSAPP.CHECK_CASH_PROPOSAL p
 where i.proposal_id = p.proposal_id
   and p.date_from >= to_date('&from_date', 'YYYY/MM/DD')
   and p.date_to <= to_date('&to_date', 'YYYY/MM/DD')
   /*and p.short_name = 'SCOMBAL02'*/
   /*and i.payment_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')*/
 order by i.proposal_id, i.item_id;

--Proposal Item & Check Encashment
select i.proposal_id,
       i.item_id,
       i.payment_date,
       c.encashment_id,
       c.payment_date,
       c.amount,
       c.contract,
       c.order_no,
       c.check_no,
       c.series_id,
       c.customer_id,
       c.bank_id,
       IFSAPP.HPNRET_BANK_API.Get_Name(c.bank_id) bank_name,
       c.last_dd_no
  from IFSAPP.CHECK_ENCASHMENT_TAB c, IFSAPP.CHECK_CASH_PROPOSAL_ITEM i
 where c.check_no = i.ledger_item_id
   and c.series_id = i.ledger_item_series_id
   and c.customer_id = i.identity
   /*and c.payment_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')*/
   and i.payment_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and c.bank_id = '14'
   /*and c.order_no is null*/
 order by i.proposal_id, i.item_id;

--Proposal Item & Voucher
select g.voucher_type,
       g.voucher_no,
       g.row_no,
       g.voucher_date,
       g.account_desc,
       g.code_b,
       g.credit_amount,
       g.party_type_id,
       g.reference_serie,
       g.reference_number
  from IFSAPP.GEN_LED_VOUCHER_ROW g, IFSAPP.CHECK_CASH_PROPOSAL_ITEM i
 where g.reference_serie = i.ledger_item_series_id
   and g.reference_number = i.ledger_item_id
   and g.party_type_id = i.identity
   and g.voucher_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and g.credit_amount is not null

--Proposal, Proposal Item & Voucher
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
       i.full_curr_amount,
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
       g.reference_number
  from IFSAPP.CHECK_CASH_PROPOSAL_ITEM i, IFSAPP.CHECK_CASH_PROPOSAL p, IFSAPP.GEN_LED_VOUCHER_ROW g
 where i.proposal_id = p.proposal_id
   and g.reference_serie = i.ledger_item_series_id
   and g.reference_number = i.ledger_item_id
   and g.party_type_id = i.identity
   and g.voucher_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and g.credit_amount is not null
   and p.short_name = 'SCOMBAL02'
 order by i.proposal_id, i.item_id;

--Proposal, Proposal Item Voucher & Check Encash
select p.proposal_id,
       i.item_id,
       p.date_from,
       p.date_to,
       i.payment_date,
       p.contract,
       p.proposal_no,
       p.short_name ACCOUNT_NO,
       IFSAPP.CASH_ACCOUNT_API.Get_Account_Identity(p.company, p.short_name) ACCOUNT_NO_DT,
       IFSAPP.CASH_ACCOUNT_API.Get_Description(p.company, p.short_name) ACCOUNT_NAME,
       i.full_curr_amount,
       i.ledger_item_id,
       substr(i.ledger_item_id, 0, instr(i.ledger_item_id, '#') - 1) DDNO,
       substr(i.ledger_item_id, instr(i.ledger_item_id, '#') + 1, 11) DD_DATE,
       i.ledger_item_series_id,
       i.identity,
       g.voucher_type,
       g.voucher_no,
       g.row_no,
       g.voucher_date,
       g.account_desc,
       g.code_b,
       g.credit_amount,
       g.party_type_id,
       g.reference_serie,
       g.reference_number,
       c.encashment_id,
       c.payment_date,
       c.amount,
       c.order_no,
       c.check_no,
       c.series_id,
       c.customer_id,
       c.bank_id,
       c.last_dd_no
  from IFSAPP.CHECK_CASH_PROPOSAL_ITEM i,
       IFSAPP.CHECK_CASH_PROPOSAL      p,
       IFSAPP.GEN_LED_VOUCHER_ROW      g,
       IFSAPP.CHECK_ENCASHMENT_TAB     c
 where i.proposal_id = p.proposal_id
   and g.reference_serie = i.ledger_item_series_id
   and g.reference_number = i.ledger_item_id
   and g.party_type_id = i.identity
   and c.check_no = i.ledger_item_id
   and c.series_id = i.ledger_item_series_id
   and c.customer_id = i.identity
   and g.voucher_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and g.credit_amount is not null
   and p.short_name = 'SCOMBAL02'
   and c.bank_id = '14'
 order by i.proposal_id, i.item_id;

--List of Encashments against Proposals
select c.encashment_id,
       c.check_no,
       c.customer_id,
       c.series_id,
       c.amount,
       c.payment_date,
       c.bank_id,
       c.rowstate
  from CHECK_ENCASHMENT_TAB c
 where c.check_no in
       (select i.ledger_item_id --Proposal, Proposal Item & Voucher
          from IFSAPP.CHECK_CASH_PROPOSAL_ITEM i,
               IFSAPP.CHECK_CASH_PROPOSAL      p,
               IFSAPP.GEN_LED_VOUCHER_ROW      g
         where i.proposal_id = p.proposal_id
           and g.reference_serie = i.ledger_item_series_id
           and g.reference_number = i.ledger_item_id
           and g.party_type_id = i.identity
           and g.voucher_date between to_date('&from_date', 'YYYY/MM/DD') and
               to_date('&to_date', 'YYYY/MM/DD')
           and g.credit_amount is not null
           and p.short_name = 'SCOMBAL02')
 order by c.check_no, c.customer_id, c.series_id;
