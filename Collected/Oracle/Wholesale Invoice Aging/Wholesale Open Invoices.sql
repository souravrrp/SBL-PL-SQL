--***** Wholesale Open Invoices
select o.*,
       ifsapp.customer_info_api.Get_Name(o.identity) dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(o.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(o.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(o.identity, 1) dealer_address,
       (select i.pay_term_id
          from IFSAPP.INVOICE_TAB i
         where i.invoice_id = o.invoice_id) pay_term_id,
       (trunc(sysdate) - trunc(o.ledger_date) + 1) age
  from IFSAPP.LEDGER_ITEM_CU_DET_QRY o
 where o.identity like 'W000%' /*'W0001044-2'*/
   and o.open_amount > 0
   /*and o.ROWTYPE != 'InvoiceLedgerItem'*/