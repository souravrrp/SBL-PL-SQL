-- List of Cash Converted Accounts
select (SELECT H.AREA_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = S.SITE) AREA_CODE,
       (SELECT H.DISTRICT_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = S.SITE) DISTRICT_CODE,
       s.site,
       s.order_no,
       s.bb_no,
       trunc(ifsapp.hpnret_hp_dtl_api.Get_Sales_Date(s.order_no,
                                                     1,
                                                     s.acct_line_no)) sales_date,
       s.sales_date cash_conversion_date,
       s.status,
       s.customer_no,
       ifsapp.customer_info_api.Get_Name(s.customer_no) customer_name,
       s.product_code,
       p.product_family,
       p.brand,
       s.sales_quantity,
       s.sales_price
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.product_code = p.product_code
 where s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and s.status = 'CashConverted'
   and s.sales_price != 0
   and s.pay_term_id != '0'
 order by 2, 3, 4
