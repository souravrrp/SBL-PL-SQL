/* Formatted on 1/29/2023 4:40:35 PM (QP5 v5.381) */
SELECT se.contract                                         shop_code,
       stt.transaction_code,
       stt.transaction_type,
       se.statement_date,
       ed.curr_amount,
       ed.identity                                         supplier_id,
       ifsapp.customer_info_api.get_name (ed.identity)     supplier_name,
       SUBSTR (ed.slmo_ledger_item_id,
               0,
               INSTR (ed.slmo_ledger_item_id, '#') - 1)    ddno,
       SUBSTR (ed.slmo_ledger_item_id,
               INSTR (ed.slmo_ledger_item_id, '#') + 1,
               LENGTH (ed.slmo_ledger_item_id))            dd_date,
       ed.remarks,
       ed.voucher_no,
       ed.voucher_date,
       stt.account,
       se.exp_statement_no
  --,ed.*
  --,stt.*
  --,se.*
  FROM ifsapp.site_expenses_detail_tab    ed,
       ifsapp.site_transaction_types_tab  stt,
       ifsapp.site_expenses_tab           se
 WHERE     ed.company = stt.company
       AND ed.transaction_code = stt.transaction_code
       AND stt.TRANSACTION_CODE LIKE '&TRANSACTION_CODE'
       AND ed.EXP_STATEMENT_ID = se.EXP_STATEMENT_ID
       AND se.CONTRACT LIKE '&CONTRACT'
       AND TRUNC (ed.LUMP_SUM_TRANS_DATE) BETWEEN TO_DATE ('&FROM_DATE',
                                                           'YYYY/MM/DD')
                                              AND TO_DATE ('&TO_DATE',
                                                           'YYYY/MM/DD')
       AND ed.ROWSTATE NOT IN ('Cancelled')
--ORDER BY s.CONTRACT;