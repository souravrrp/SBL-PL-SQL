-- GL Voucher Details
select t.company,
       t.voucher_type,
       t.accounting_year,
       t.voucher_no,
       t.row_no,
       t.internal_seq_number,
       t.posting_combination_id,
       t.voucher_date,
       t.trans_code,
       t.currency_debet_amount,
       t.currency_credit_amount,
       t.currency_code,
       t.debet_amount,
       t.credit_amount,
       t.quantity,
       t.text,
       t.party_type_id,
       t.reference_serie,
       t.reference_number,
       t.corrected,
       t.account,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', T.ACCOUNT) ACCOUNT_Description,
       t.code_b,
       t.code_c,
       t.rowversion /*count(*)*/
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB t
 where /*t.account like '2%'*/ /*(t.account like '6%' or t.account like '7%' or t.account like '8%' or
                   t.account like '9%')*/
   /*and*/ t.account /*not in ('10020040',
                               '10020050',
                               '10020910',
                               '10030010',
                               '10060010',
                               '10070900',
                               '10100020',
                               '10110010',
                               '10120160',
                               '20010050',
                               '20010099',
                               '40000000',
                               '50000000')*/
       = /*'10120890'*/ /*'20010010'*/ '20010200'
   and t.voucher_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and t.voucher_type /*= 'N'*/ in ('U', 'N')
