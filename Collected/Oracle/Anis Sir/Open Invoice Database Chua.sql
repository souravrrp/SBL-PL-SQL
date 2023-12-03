--Open Invoice Database Chua (Trade Receivable)
select IFSAPP.INVOICE_API.Get_Invoice_No(T.company,
                                         T.identity,
                                         T.party_type,
                                         T.invoice_id) INVOICE_NO,
       t.ledger_date invoice_date,
       t.identity customer_code,
       IFSAPP.CUSTOMER_INFO_API.Get_Name(t.identity) customer_name,
       --'Credit Term',
       t.ledger_item_series_id,
       /*t.ledger_item_id,*/
       t.voucher_no,
       t.voucher_type,
       t.due_date,
       IFSAPP.INVOICE_API.Get_Delivery_Date(T.company,
                                            T.identity,
                                            T.party_type,
                                            T.invoice_id) delivery_date,
       t.open_amount
  from IFSAPP.LEDGER_ITEM_CU_DET_QRY t
 where t.open_amount != 0
   and t.ledger_item_series_id = 'SDDLRS'
   /*and t.ledger_date <= to_date('&date', 'YYYY/MM/DD')*/
   and t.identity like 'W000%'
 order by t.ledger_date
