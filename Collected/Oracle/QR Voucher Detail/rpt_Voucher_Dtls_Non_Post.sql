select vr.voucher_type
    ,vr.voucher_no
    ,to_char(vr.voucher_date,'YYYY/MM/DD') Voucher_Date
    ,v.voucher_text
    ,v.userid
    ,v.approved_by_userid
    ,vr.account
    ,decode(vr.account, null, null, 
      substr(text_field_translation_api.Get_Text(vr.company, 'CODEA', vr.account), 1, 100)) account_Desc
    ,vr.code_b
    ,nvl(vr.currency_credit_amount, 0) credit_amount
    ,nvl(vr.currency_debet_amount, 0) debit_amount
    ,vr.text
  from voucher_row_tab vr
      ,voucher_tab v
  where vr.voucher_type = v.voucher_type
      and vr.voucher_no = v.voucher_no
      and vr.voucher_date = v.voucher_date
      
      /*and vr.voucher_type like '&Voucher_Type'
      and vr.voucher_no like '&Voucher_No'
      and vr.voucher_date between to_date('&From_Date','YYYY/MM/DD') and to_date('&To_Date','YYYY/MM/DD')*/
      
      and vr.voucher_type like decode('&Voucher_Type', null, '%', '&Voucher_Type')
      and vr.voucher_no like decode('&Voucher_No', null, '%', '&Voucher_No')
      and vr.voucher_date between decode('&From_Date', null, to_date('2013/8/1','YYYY/MM/DD'),to_date('&From_Date', 'YYYY/MM/DD')) 
                and decode('&To_Date', null, sysdate, to_date('&To_Date', 'YYYY/MM/DD'))
    order by vr.voucher_date,vr.voucher_type,vr.voucher_no;
