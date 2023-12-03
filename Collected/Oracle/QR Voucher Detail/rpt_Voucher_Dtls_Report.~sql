select gvr.voucher_type
      ,gvr.voucher_no
      ,to_char(gvr.voucher_date,'YYYY/MM/DD') Voucher_Date
      ,gv.voucher_text
      ,gv.userid
      ,gv.approved_by_userid
      ,gvr.account
      ,decode(gvr.account, null, null,
          substr(text_field_translation_api.Get_Text(gvr.company,'CODEA',gvr.account),1,100)) account_desc
      ,gvr.code_b
      ,nvl(gvr.currency_credit_amount, 0) Credit_Amount
      ,nvl(gvr.currency_debet_amount, 0) Debit_Amount
      ,gvr.text
  from gen_led_voucher_row_tab gvr
    ,gen_led_voucher_tab gv
  where gvr.voucher_type = gv.voucher_type
    and gvr.voucher_no = gv.voucher_no
    and gvr.voucher_date = gv.voucher_date
    
    /*and gvr.voucher_type like '&Voucher_Type'
    and gvr.voucher_no like '&Voucher_No'
    and gvr.voucher_date between to_date('&From_Date', 'YYYY/MM/DD') and to_date('&To_Date', 'YYYY/MM/DD')*/
    
    and gvr.voucher_type like decode('&Voucher_Type', null, '%', '&Voucher_Type')
    and gvr.voucher_no like decode('&Voucher_No', null, '%', '&Voucher_No')
    and gvr.voucher_date between decode('&From_Date', null, to_date('2013/6/1','YYYY/MM/DD'),to_date('&From_Date', 'YYYY/MM/DD')) 
              and decode('&To_Date', null, sysdate, to_date('&To_Date', 'YYYY/MM/DD'))
  order by gvr.voucher_type,gvr.voucher_no,gvr.voucher_date;
