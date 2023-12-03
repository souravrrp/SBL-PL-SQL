select P.CONTRACT, --distinct
       p.proposal_no,
       --G.FULLY_PAID_VOUCHER_DATE,
       G.VOUCHER_DATE,
       substr(I.LEDGER_ITEM_ID, 0, instr(I.LEDGER_ITEM_ID, '#') - 1) DDNO,
       (SELECT IFSAPP.HPNRET_BANK_API.Get_Name(BANK_ID)
          FROM IFSAPP.CHECK_ENCASHMENT_TAB T
         WHERE T.CHECK_NO = I.LEDGER_ITEM_ID
           and t.SERIES_ID = I.LEDGER_ITEM_SERIES_ID
           and t.CUSTOMER_ID = i.identity
           and t.rowstate = 'Approved') BANK_NAME,
       i.FULL_CURR_AMOUNT AMOUNT,
       P.SHORT_NAME ACCOUNT_NO,
       IFSAPP.CASH_ACCOUNT_API.Get_Account_Identity(P.COMPANY, p.SHORT_NAME) ACCOUNT_NO_DT,
       IFSAPP.CASH_ACCOUNT_API.Get_Description(P.COMPANY, p.SHORT_NAME) ACCOUNT_NAME,
       substr(I.LEDGER_ITEM_ID, instr(I.LEDGER_ITEM_ID, '#') + 1, 11) DD_DATE,
       (SELECT t.LAST_DD_NO
          FROM IFSAPP.CHECK_ENCASHMENT_TAB T
         WHERE T.CHECK_NO = I.LEDGER_ITEM_ID
           and t.SERIES_ID = I.LEDGER_ITEM_SERIES_ID
           and t.CUSTOMER_ID = i.identity
           and t.rowstate = 'Approved') LAST_DDNO,
       decode((SELECT t.LAST_DD_NO
                FROM ifsapp.CHECK_ENCASHMENT_TAB T
               WHERE T.CHECK_NO = I.LEDGER_ITEM_ID
                 and t.SERIES_ID = I.LEDGER_ITEM_SERIES_ID
                 and t.CUSTOMER_ID = i.identity
                 and t.rowstate = 'Approved'),
              NULL,
              substr(I.LEDGER_ITEM_ID, 0, instr(I.LEDGER_ITEM_ID, '#') - 1),
              (SELECT t.LAST_DD_NO
                 FROM ifsapp.CHECK_ENCASHMENT_TAB T
                WHERE T.CHECK_NO = I.LEDGER_ITEM_ID
                  and t.SERIES_ID = I.LEDGER_ITEM_SERIES_ID
                  and t.CUSTOMER_ID = i.identity
                  and t.rowstate = 'Approved')) DDNO_FINAL,
       g.voucher_no,
       g.text
       --(select v.text from gen_led_voucher_row_tab v where v.voucher_no = g.voucher_no and v.voucher_type = g.voucher_type and g.credit_amount != 0) VOUCHER_TEXT
       --(select v.text from gen_led_voucher_row_tab v where v.reference_serie = i.ledger_item_series_id and v.party_type_id = i.identity and v.reference_number = i.ledger_item_id and v.credit_amount is not null) VOUCHER_TEXT
  from IFSAPP.CHECK_CASH_PROPOSAL      P,
       IFSAPP.CHECK_CASH_PROPOSAL_ITEM I,
       IFSAPP.gen_led_voucher_row_tab  G /*CHECK_LEDGER_ITEM*/
       --IFSAPP.GEN_LED_VOUCHER_ROW_UNION_QRY G
 where p.PROPOSAL_ID = i.PROPOSAL_ID
   and I.LEDGER_ITEM_SERIES_ID = G.REFERENCE_SERIE
   and I.identity = G.PARTY_TYPE_ID
   and I.LEDGER_ITEM_ID = G.REFERENCE_NUMBER
   and P.SHORT_NAME like '&ACCOUNT_NO' 
   and G.VOUCHER_DATE BETWEEN TO_DATE('&From_Date', 'YYYY/MM/DD') AND
       TO_DATE('&To_Date', 'YYYY/MM/DD')
   and P.CONTRACT like '&SITE'
   AND (SELECT upper(IFSAPP.HPNRET_BANK_API.Get_Name(BANK_ID))
          FROM IFSAPP.CHECK_ENCASHMENT_TAB T
         WHERE T.CHECK_NO = I.LEDGER_ITEM_ID
           and t.SERIES_ID = I.LEDGER_ITEM_SERIES_ID
           and t.CUSTOMER_ID = i.identity
           and t.rowstate = 'Approved') LIKE upper('%&BANK_NAME%')
   and g.credit_amount is not null
   --and I.LEDGER_ITEM_ID=G.LEDGER_ITEM_ID
   --and I.identity=G.identity
   --and I.LEDGER_ITEM_SERIES_ID=G.LEDGER_ITEM_SERIES_ID
   --AND trunc(G.FULLY_PAID_VOUCHER_DATE)  BETWEEN TO_DATE('&From_Date','YYYY/MM/DD') AND TO_DATE('&To_Date','YYYY/MM/DD')
   --and p.proposal_no = 'LFBB_89'
