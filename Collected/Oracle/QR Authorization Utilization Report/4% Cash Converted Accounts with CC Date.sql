--4% Cash Converted Accounts with CC Date
select t.account_no,
       t.variation_db Variation_ID,
       Variation_API.Decode(t.variation_db) Variation_Name,
       ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                         t.account_rev) Original_Sales_Date,
       (select f.cash_conversion_on_date
          from ifsapp.HPNRET_FORM249_ARREARS_TAB f
         where f.year =
               extract(year from
                       ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                         t.account_rev))
           and f.period =
               extract(month from
                       ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                         t.account_rev))
           and f.acct_no = t.account_no) cash_conversion_on_date,
       to_char(t.from_date, 'YYYY/MM/DD') Permission_Date,
       to_char(t.to_date, 'YYYY/MM/DD') Last_Date,
       trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                       t.account_rev)) Closed_Date,
       t.utilized Service_Utilized,
       /*t.discount "Discount",
       t.discount_percentage "Discount Percent",*/
       t.service_charge
  from IFSAPP.HPNRET_AUTH_VARIATION t
 where t.utilized = 1
   and t.variation_db = '&variation'
   and trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                       t.account_rev)) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and t.from_date <= to_date('&to_date', 'YYYY/MM/DD')
   and t.to_date >= to_date('&from_date', 'YYYY/MM/DD')
   and t.service_charge > 0
 order by t.from_date, t.account_no;

/*Variation ID
1 = Early Closure
2 = Exchange
3 = Return
4 = Term Extension
5 = Revert Reverse
6 = Cash Conversion
8 = Transfer Account
9 = Assume
10 = CO Exchange
11 = CO Returns*/
