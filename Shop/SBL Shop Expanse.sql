/* Formatted on 3/29/2023 1:51:02 PM (QP5 v5.381) */
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
    FROM ifsapp.site_expenses_detail_tab  ed,
         ifsapp.site_transaction_types_tab stt,
         ifsapp.site_expenses_tab         se
   WHERE     ed.company = stt.company
         AND ed.transaction_code = stt.transaction_code
         AND ed.exp_statement_id = se.exp_statement_id
         AND (   :p_shop_code IS NULL
              OR (UPPER (se.contract) = UPPER ( :p_shop_code)))
         AND TRUNC (ed.lump_sum_trans_date) BETWEEN NVL (
                                                        :p_date_from,
                                                        TRUNC (
                                                            ed.lump_sum_trans_date))
                                                AND NVL (
                                                        :p_date_to,
                                                        TRUNC (
                                                            ed.lump_sum_trans_date))
         AND ed.rowstate NOT IN ('Cancelled')
ORDER BY se.contract;