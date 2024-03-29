-- HP Sales having UnPaid Amount
select t.*,
       ifsapp.hpnret_hp_head_api.Get_Total_Amt_Paid(t.account_no,
                                                    t.account_rev) amt_paid
  from ifsapp.HPNRET_HP_HEAD t
 where t.sales_date between to_date('2019/12/1', 'YYYY/MM/DD') and
       to_date('2019/12/31', 'YYYY/MM/DD')
      /*and t.account_no = \*'GSG-H2366'*\ 'NTK-H5007'*/
   and t.state /*!= 'Closed'*/
       = 'Active'
   and ifsapp.hpnret_hp_head_api.Get_Total_Amt_Paid(t.account_no,
                                                    t.account_rev) = 0
   and (select d.catalog_type
          from ifsapp.HPNRET_HP_DTL_TAB d
         where d.account_no = t.account_no
           and d.account_rev = 1
           and d.line_no = 1) != 'PKG';

-- Cash Sales having UnPaid Amount
select c.*,
       ifsapp.hpnret_customer_order_api.Get_Tot_Unpaid(c.order_no) unpaid
  from ifsapp.HPNRET_CUSTOMER_ORDER c
 inner join ifsapp.shop_dts_info s
    on c.contract = s.shop_code
 where ifsapp.hpnret_customer_order_api.Get_Tot_Unpaid(c.order_no) > 0
   and trunc(c.date_entered) between to_date('2019/12/1', 'YYYY/MM/DD') and
       to_date('2019/12/31', 'YYYY/MM/DD');
