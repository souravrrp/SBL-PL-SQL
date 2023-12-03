--***** Cash Close Load Details
select b.area_code,
       b.district_code,
       b.shop_code,
       b.account_no,
       b.bb_no,
       b.variation_name,
       b.utilized,
       b.original_sales_date,
       b.cash_conversion_on_date,
       b.permission_date,
       b.last_date,
       b.closed_date,
       b.out_balance_till_cc_period out_balance,
       b.load_amount,
       b.promo_load_pc,
       b.user_id
  from (select a.*,
               nvl((select sum(c.amount) amount
                     from ifsapp.SBL_COLLECTION_INFO c
                    where c.account_no = a.account_no
                      and c.payment_date between a.Original_Sales_Date and
                          a.cash_conversion_on_date),
                   0) coll_till_cc_period,
               (a.hire_cash_price - a.down_payment -
               (nvl((select sum(c.amount) amount
                       from ifsapp.SBL_COLLECTION_INFO c
                      where c.account_no = a.account_no
                        and c.payment_date between a.Original_Sales_Date and
                            a.cash_conversion_on_date),
                     0))) out_balance_till_cc_period
          from (select ifsapp.hpnret_hp_head_api.Get_Contract(t.account_no,
                                                              t.account_rev) shop_code,
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
                       ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(t.account_no,
                                                                         t.account_rev) bb_no,
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
                       t.utilized,
                       ifsapp.hpnret_hp_head_api.Get_Gross_Hire_Value(t.account_no,
                                                                      t.account_rev) Gross_Hire_Value,
                       IFSAPP.HPNRET_HP_HEAD_API.Get_Total_Ucc(t.account_no,
                                                               t.account_rev) Total_Ucc,
                       IFSAPP.HPNRET_HP_HEAD_API.Get_Total_Serv_Chg(t.account_no,
                                                                    t.account_rev) Serv_Chg,
                       IFSAPP.HPNRET_HP_HEAD_API.Get_Total_Down_Pay(t.account_no,
                                                                    t.account_rev) down_payment,
                       (ifsapp.hpnret_hp_head_api.Get_Gross_Hire_Value(t.account_no,
                                                                       t.account_rev) -
                       IFSAPP.HPNRET_HP_HEAD_API.Get_Total_Ucc(t.account_no,
                                                                t.account_rev) -
                       IFSAPP.HPNRET_HP_HEAD_API.Get_Total_Serv_Chg(t.account_no,
                                                                     t.account_rev)) hire_cash_price,
                       (t.from_date -
                       ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                          t.account_rev)) days_from_sale,
                       t.service_charge load_amount,
                       case
                         when (t.from_date -
                              ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                                 t.account_rev)) < 186 then
                          '0'
                         when (t.from_date -
                              ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                                 t.account_rev)) between 186 and 210 then
                          '4'
                         when (t.from_date -
                              ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                                 t.account_rev)) between 211 and 240 then
                          '8'
                         when (t.from_date -
                              ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                                 t.account_rev)) between 241 and 270 then
                          '12'
                         when (t.from_date -
                              ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                                 t.account_rev)) between 271 and 300 then
                          '16'
                         when (t.from_date -
                              ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                                 t.account_rev)) between 301 and 330 then
                          '20'
                         when (t.from_date -
                              ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date(t.account_no,
                                                                                 t.account_rev)) between 331 and 360 then
                          '24'
                         else
                          ''
                       end "PROMO_LOAD_PC",
                       t.user_id
                  from IFSAPP.HPNRET_AUTH_VARIATION t
                 where t.utilized = 1
                   and t.variation_db = 6 --'&variation'
                   and t.to_date >= to_date('&from_date', 'YYYY/MM/DD')
                   and t.from_date <= to_date('&to_date', 'YYYY/MM/DD')
                   and trunc(ifsapp.hpnret_hp_head_api.Get_Closed_Date(t.account_no,
                                                                       t.account_rev)) between
                       to_date('&from_date', 'YYYY/MM/DD') and
                       to_date('&to_date', 'YYYY/MM/DD')
                   and t.service_charge > 0) a) b;