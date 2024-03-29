--4 & 8% Cash Converted Account Monthly Summary with Discounted Cash Price & Service Charge
select extract(year
               from(trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                                    t.account_rev)))) "YEAR",
       extract(month
               from(trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                                    t.account_rev)))) "PERIOD",
       /*sum(ifsapp.hpnret_hp_head_api.Get_Nor_Cash_Price_Dis(t.account_no,
                                                            t.account_rev)) total_discounted_cash_price,
       sum(t.service_charge) total_service_charge,*/
       count(t.account_no) no_of_accounts
  from IFSAPP.HPNRET_AUTH_VARIATION t
 where t.utilized = 1
   and t.variation_db = '&variation'
   and t.to_date >= to_date('&from_date', 'YYYY/MM/DD')
   and t.from_date <= to_date('&to_date', 'YYYY/MM/DD')
   and trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                       t.account_rev)) between
       to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and t.service_charge > 0
 group by extract(year
                  from(trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                                       t.account_rev)))),
          extract(month
                  from(trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                                       t.account_rev))));

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
