--Cumulative Revert CD Values --
--Run below SQL as at 2017/01/31

SELECT ifsapp.Identity_Invoice_Info_API.Get_Group_Id('SBL',
                                                     t.identity,
                                                     'Customer') Customer_Group,
       --t.creators_reference acct_no,t.invoice_no,
       SUM(ifsapp.ledger_item_api.Get_Full_Curr_Amount(t.company,
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
 WHERE t.creators_reference IN
       (select distinct (h.account_no)
          from ifsapp.hpnret_hp_dtl_tab h
         where trunc(h.reverted_date) <= to_date('&to_date', 'yyyy/mm/dd'))
   and trunc(t.invoice_date) <= to_date('&to_date', 'yyyy/mm/dd')
   and t.series_id = 'CD'
   AND ifsapp.Identity_Invoice_Info_API.Get_Group_Id('SBL',
                                                     t.identity,
                                                     'Customer') in
       ('0', 'EMP', 'TDCORP')
 group by ifsapp.Identity_Invoice_Info_API.Get_Group_Id('SBL',
                                                        t.identity,
                                                        'Customer')

--AND Identity_Invoice_Info_API.Get_Group_Id('SBL', t.identity, 'Customer') = '0' -- Normal(10060010) CD= 768145
--AND Identity_Invoice_Info_API.Get_Group_Id('SBL',t.identity,'Customer')='EMP'    -- EMP (10070100) CD= 0
--AND Identity_Invoice_Info_API.Get_Group_Id('SBL',t.identity,'Customer')='TDCORP' -- TDCORP (10070080) CD= 0
