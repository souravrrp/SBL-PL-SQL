--4 & 8% Cash Converted Accounts with CC Date
select ifsapp.hpnret_hp_head_api.Get_Contract(t.account_no, t.account_rev) shop_code,
       (SELECT H.AREA_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE =
               ifsapp.hpnret_hp_head_api.Get_Contract(t.account_no,
                                                      t.account_rev)) AREA_CODE,
       (SELECT H.DISTRICT_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE =
               ifsapp.hpnret_hp_head_api.Get_Contract(t.account_no,
                                                      t.account_rev)) DISTRICT_CODE,
       t.account_no,
       t.variation_db Variation_ID,
       Variation_API.Decode(t.variation_db) Variation_Name,
       ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                         t.account_rev) Original_Sales_Date,
       (select f.cash_conversion_on_date
          from ifsapp.HPNRET_FORM249_ARREARS_TAB f
         where f.acct_no = t.account_no
           and f.year = extract(year from add_months(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                                                     t.account_rev),
                                           -1))
           and f.period = extract(month from add_months(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                                                       t.account_rev),
                                             -1))) cash_conversion_on_date,
       t.from_date Permission_Date,
       t.to_date Last_Date,
       trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                       t.account_rev)) Closed_Date,
       t.utilized Service_Utilized,
       t.discount "Discount",
       t.discount_percentage "Discount Percent",
       ifsapp.hpnret_hp_head_api.Get_Nor_Cash_Price_Dis(t.account_no, t.account_rev) discounted_cash_price,       
       (select f.act_out_bal
          from ifsapp.HPNRET_FORM249_ARREARS_TAB f
         where f.acct_no = t.account_no
           and f.year = extract(year from add_months(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                                                     t.account_rev),
                                           -1))
           and f.period = extract(month from add_months(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                                                       t.account_rev),
                                             -1))) act_out_bal,
       t.service_charge
  from IFSAPP.HPNRET_AUTH_VARIATION t
 where t.utilized = 1
   and t.variation_db = '&variation'
   and t.to_date >= to_date('&from_date', 'YYYY/MM/DD')
   and t.from_date <= to_date('&to_date', 'YYYY/MM/DD')
   and trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                       t.account_rev)) between
       to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and t.service_charge > 0;

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
