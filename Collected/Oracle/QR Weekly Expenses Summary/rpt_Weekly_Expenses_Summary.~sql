SELECT ifsapp.bcb_statement_api.Get_Bcb_Statement_No(b.company,
                                                     b.bcb_statement_id) BCB_No,
       ifsapp.bcb_statement_api.get_contract(b.company, b.bcb_statement_id) contract,
       ifsapp.site_api.Get_Description(ifsapp.bcb_statement_api.get_contract(b.company,
                                                                             b.bcb_statement_id)) Site_Name,
       d.transaction_code,
       ifsapp.site_transaction_types_api.Get_Transaction_Type('SBL',
                                                              d.transaction_code) Tran_Type,
       b.dom_amount,
       b.under_remitted,
       b.expense_check,
       b.check_user_id,
       b.date_checked
  FROM ifsapp.site_transaction_types t,
       ifsapp.site_expenses_detail   d,
       ifsapp.bcb_statement_details  b
 WHERE t.site_transaction_category_db = 2
   AND t.mp_mapping_trans_type_db = 'DIRECTCASHTRANS'
   AND t.transaction_code = d.transaction_code
   AND d.lump_sum_trans_date BETWEEN to_date('&From_Date', 'YYYY/MM/DD') AND
       TO_DATE('&To_Date', 'YYYY/MM/DD')
   AND b.bcb_statement_id = d.bcb_statement_id_ref
   AND b.bcb_lump_sum_trans_id = d.bcb_lump_sum_trans_id_ref
   AND b.company = d.company
