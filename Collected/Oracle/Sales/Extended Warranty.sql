--***** CO Extended Warranty
select t.*, ifsapp.hpnret_customer_order_api.Get_Tot_Unpaid(t.order_no) tot_unpaid, ifsapp.hpnret_customer_order_api.Get_Tot_Paid(t.order_no) tot_paid
  from IFSAPP.HPNRET_CUST_ORDER_LINE t
 where t.ext_warranty = 1 /*is null*/
   and t.state != 'Cancelled'
   and trunc(t.date_entered) between to_date('2019/1/1', 'yyyy/mm/dd') and to_date('2019/12/31', 'yyyy/mm/dd')
   and ifsapp.hpnret_customer_order_api.Get_Tot_Unpaid(t.order_no) is null;

--***** HP Extended Warranty
select t.*, ifsapp.hpnret_hp_head_api.Get_Total_Out_Bal(t.account_no, t.account_rev) out_bal
  from IFSAPP.HPNRET_HP_DTL t
 where t.ext_warranty = 1 /*is null*/
   and t.state != 'Cancelled'
   and t.sales_date between to_date('2018/1/1', 'yyyy/mm/dd') and to_date('2018/12/31', 'yyyy/mm/dd')
   and ifsapp.hpnret_hp_head_api.Get_Total_Out_Bal(t.account_no, t.account_rev) > 0;
