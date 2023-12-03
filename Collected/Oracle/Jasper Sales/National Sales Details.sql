--***** National Sales Details
select s.*,
       p.product_family,
       p.brand,
       (SELECT H.AREA_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = S.SITE) AREA_CODE,
       (SELECT H.DISTRICT_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = S.SITE) DISTRICT_CODE,
       ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(s.order_no, 1) bb_no/*,*/
       /*ifsapp.customer_info_api.Get_Name(s.customer_no) customer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(s.customer_no) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(s.customer_no, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(s.customer_no, 1) customer_address,*/
       /*case
         when ifsapp.hpnret_hp_head_api.Get_Closed_Date(s.order_no, 1) is not null then
          (select f.cash_conversion_on_date
             from ifsapp.HPNRET_FORM249_ARREARS_TAB f
            where f.acct_no = s.order_no
              and f.year =
                  extract(year from
                          ifsapp.hpnret_hp_head_api.Get_Closed_Date(s.order_no,
                                                                    1))
              and f.period =
                  extract(month from
                          ifsapp.hpnret_hp_head_api.Get_Closed_Date(s.order_no,
                                                                    1)))
         else
          (select f.cash_conversion_on_date
             from ifsapp.HPNRET_FORM249_ARREARS_TAB f
            where f.acct_no = s.order_no
              and f.year = extract(year from(trunc(sysdate, 'mm') - 1))
              and f.period = extract(month from(trunc(sysdate, 'mm') - 1)))
       end cash_conversion_on_date,
       ifsapp.hpnret_hp_head_api.Get_Closed_Date(s.order_no, 1) closed_date,
       case
         when s.sales_price > 0 then
          ifsapp.hpnret_hp_dtl_api.Get_Amt_Finance(s.order_no, 1, s.line_no)
         else
          0
       end Amt_Finance,
       case
         when s.sales_price > 0 then
          ifsapp.hpnret_hp_dtl_api.Get_Down_Payment(s.order_no, 1, s.line_no)
         else
          0
       end down_payment,
       case
         when s.sales_price > 0 then
          ifsapp.hpnret_hp_dtl_api.Get_Install_Amt(s.order_no, 1, s.line_no)
         else
          0
       end install_amt,
       ifsapp.hpnret_hp_head_api.Get_Length_Of_Contract(s.order_no, 1) loc,
       ifsapp.hpnret_hp_head_api.Get_Total_Out_Bal(s.order_no, 1) out_bal,
       ifsapp.hpnret_hp_head_api.Get_Total_Serv_Chg(s.order_no, 1) service_charge*/
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.product_code = p.product_code
 where s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
               to_date('&TO_DATE', 'YYYY/MM/DD')
/*and s.status in ('ExchangedIn', 'PositiveExchangedIn')*/
and s.sales_price != 0
/*and s.site = 'SAPM'*/
/*and substr(s.order_no, 4, 2) = '-H'*/
/*and ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(s.order_no, 1) = \*'SP-32'*\ 'GR-28'*/
/*and s.order_no = 'RAM-H2647'*/
;

--***** Total VAT Amount
select sum(s.vat) total_vat
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 where s.sales_price != 0
   and s.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD');
