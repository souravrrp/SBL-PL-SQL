select * from LEDGER_ITEM_TAB li

select distinct(li.rowstate) from LEDGER_ITEM_TAB li

select * from Payment_Plan_Tab p
where p.installment_id != 1

SELECT due_date,
  payment_date,
  authorized,
  auth_id
FROM   Payment_Plan_Tab
WHERE  company               = company_
AND    identity              = identity_               
AND    party_type            = party_type_db_             
AND    invoice_id            = invoice_id_  
AND    installment_id        = installment_id_;

Company_Finance_API

Payment_Library_API

Invoice_Ledger_Item_API

Check_Ledger_Item_API

select * from tabs t
where t.TABLE_NAME like '%INVOICE%'

SELECT payment_date, company, identity, party_type, ledger_item_series_id, ledger_item_id, ledger_item_version
      FROM   check_ledger_item
      WHERE  /*company               = company_
        AND  identity              = identity_
        AND  party_type            = party_type_
        AND  */ledger_item_series_id = 'EMPADV'/*ledger_item_series_id_*/
        AND  ledger_item_id        = ledger_item_id_
        AND  ledger_item_version   = ledger_item_version_;

SELECT I.Pl_Pay_Date FROM INVOICE_TAB I where i.invoice_id = 
