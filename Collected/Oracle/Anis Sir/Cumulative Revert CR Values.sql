--Revert CR Values �
--Run below SQL as at 2017/01/31

SELECT Identity_Invoice_Info_API.Get_Group_Id('SBL', t.identity, 'Customer') Customer_Group,
       --ifsapp.Return_Material_Line_Api.Get_Order_No(t.rma_no,'1') acct_no,t.invoice_no,
       sum(ifsapp.ledger_item_api.Get_Full_Curr_Amount(t.company,
                                                       t.identity,
                                                       'Customer',
                                                       t.series_id,
                                                       t.invoice_no,
                                                       '1') -
           ifsapp.ledger_item_api.get_cleared_curr_amt_at_date(t.company,
                                                               t.identity,
                                                               'Customer',
                                                               t.series_id,
                                                               t.invoice_no,
                                                               '1',
                                                               to_date('&to_date',
                                                                       'yyyy/mm/dd'))) Out_bal
  FROM ifsapp.CUSTOMER_ORDER_INV_HEAD t
 WHERE ifsapp.Return_Material_Line_Api.Get_Order_No(t.rma_no, '1') IN
       (select distinct (t.account_no)
          from ifsapp.hpnret_hp_dtl_tab t
         where trunc(t.reverted_date) <= to_date('&to_date', 'yyyy/mm/dd'))
   and trunc(t.invoice_date) <= to_date('&to_date', 'yyyy/mm/dd')
   and t.series_id = 'CR'
   AND Identity_Invoice_Info_API.Get_Group_Id('SBL', t.identity, 'Customer') in
       ('0', 'EMP', 'TDCORP')
 group by Identity_Invoice_Info_API.Get_Group_Id('SBL',
                                                 t.identity,
                                                 'Customer')

--AND Identity_Invoice_Info_API.Get_Group_Id('SBL', t.identity, 'Customer') = '0' -- Normal HP (10060010)  CR = -92786361
--AND Identity_Invoice_Info_API.Get_Group_Id('SBL',t.identity,'Customer')='EMP'     -- EMP HP(10070100)   CR =  -52100
--AND Identity_Invoice_Info_API.Get_Group_Id('SBL',t.identity,'Customer')='TDCORP'  -- TDCORP (10070080)  CR =  0
