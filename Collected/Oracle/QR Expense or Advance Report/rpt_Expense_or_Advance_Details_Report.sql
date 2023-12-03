SELECT s.CONTRACT SHOP_CODE,
       t.TRANSACTION_CODE,
       t.TRANSACTION_TYPE,
       s.STATEMENT_DATE,
       ed.CURR_AMOUNT,
       ed.IDENTITY SUPPLIER_ID,
       ifsapp.customer_info_api.Get_Name(ed.IDENTITY) SUPPLIER_NAME,
       substr(ed.SLMO_LEDGER_ITEM_ID,
              0,
              instr(ed.SLMO_LEDGER_ITEM_ID, '#') - 1) DDNO,
       substr(ed.SLMO_LEDGER_ITEM_ID,
              instr(ed.SLMO_LEDGER_ITEM_ID, '#') + 1,
              length(ed.SLMO_LEDGER_ITEM_ID)) DD_DATE
  FROM ifsapp.site_expenses_detail_tab   ed,
       ifsapp.site_transaction_types_tab t,
       ifsapp.site_expenses_tab          s
 WHERE ed.company = t.company
   AND ed.transaction_code = t.transaction_code
   and t.TRANSACTION_CODE like '&TRANSACTION_CODE'
   and ed.EXP_STATEMENT_ID = s.EXP_STATEMENT_ID
   and s.CONTRACT like '&CONTRACT'
   and trunc(ed.LUMP_SUM_TRANS_DATE) BETWEEN
       TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   and ed.ROWSTATE not in ('Cancelled')
 order by s.CONTRACT
