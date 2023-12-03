-- Retail Pay Term based Sales Details
select a.sales_channel,
       a.area_code,
       a.district_code,
       a.site,
       a.order_no,
       a.sales_date,
       a.status,
       a.pay_term,
       a.customer_no,
       a.customer_name,
       a.product_code,
       a.product_family,
       a.brand,
       a.sales_quantity,
       a.sales_price
  from (select s.*,
               case
                 when S.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'WITM') then
                  'WHOLESALE'
                 when S.SITE = 'SCSM' then
                  'CORPORATE'
                 when S.SITE = 'SITM' then
                  'IT CHANNEL'
                 when S.SITE = 'SSAM' then
                  'SMALL APPLIANCE CHANNEL'
                 when S.SITE = 'SOSM' then
                  'ONLINE CHANNEL'
                 when S.SITE in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM') then
                  'STAFF SCRAP & ACQUISITION'
                 when S.SITE in (select t.shop_code
                                   from ifsapp.shop_dts_info t
                                  where t.shop_code = S.SITE) then
                  'RETAIL'
                 else
                  'BLANK' /*'RETAIL'*/
               end sales_channel,
               (SELECT H.AREA_CODE
                  FROM IFSAPP.SHOP_DTS_INFO H
                 WHERE H.SHOP_CODE = S.SITE) AREA_CODE,
               (SELECT H.DISTRICT_CODE
                  FROM IFSAPP.SHOP_DTS_INFO H
                 WHERE H.SHOP_CODE = S.SITE) DISTRICT_CODE,
               p.product_family,
               p.brand,
               ifsapp.customer_info_api.Get_Name(s.customer_no) customer_name,
               decode(s.pay_term_id, 'CO', 'CASH', 'HP', 'HP', 'CREDIT') pay_term
          from (select *
                  from IFSAPP.SBL_JR_SALES_DTL_INV i
                union all
                select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
         inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
            on s.product_code = p.product_code
         where s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
               to_date('&TO_DATE', 'YYYY/MM/DD')
           and s.status not in ('CashConverted', 'PositiveCashConv')
           and s.sales_price != 0
           and s.pay_term_id != '0') a
 where a.sales_channel = 'RETAIL'
 order by 3, 4, 6, 5
