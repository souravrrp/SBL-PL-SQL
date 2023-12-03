select to_char(t.lump_sum_trans_date, 'YYYY/MM/DD') "Transaction Date"
    ,t.payer_identity "Customer ID"
    ,ifsapp.customer_info_api.Get_Name(t.payer_identity) "Customer Name"
    ,ifsapp.mixed_payment_api.Get_Voucher_No_Ref(t.company,t.mixed_payment_id) "Voucher No"
    ,t.text "Narration"
    ,ifsapp.mixed_payment_api.Get_Short_Name(company,mixed_payment_id) "Bank ID"
    ,t.curr_amount "Payment Amount"
  from ifsapp.mixed_payment_lump_sum_tab t
    where t.lump_sum_trans_date between  to_date('&fromdate','YYYY/MM/DD') and to_date('&todate','YYYY/MM/DD')
      and ifsapp.mixed_payment_api.Get_Short_Name(company,mixed_payment_id) like '&bankid'
      and ifsapp.t.payer_identity like '&customerid';
