--***** Channel-wise Product Model Sales Summary
select n.sales_channel,
       n.product_family,
       n.product_code,
       sum(n.sales_quantity) sales_quantity,
       sum(n.sales_price) revenue
  from (select s.*, -- National Sales
               case
                 when s.site = 'SCSM' then
                  'CORPORATE'
                 when s.site in ('JWSS', 'SAOS', 'SWSS', 'WSMO') then
                  'WHOLESALE'
                 when s.site = 'SITM' then
                  'IT CHANNEL'
                 when s.site = 'SSAM' then
                  'SMALL APPLIANCE CHANNEL'
                 when s.site = 'SOSM' then
                  'ONLINE CHANNEL'
                 when s.site in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM') then
                  'STAFF SCRAP & ACQUISITION'
                 /*when s.site in (select t.shop_code
                                   from ifsapp.shop_dts_info t
                                  where t.shop_code = s.site) then
                  'RETAIL'*/
                 else
                  /*'BLANK'*/ 'RETAIL'
               end sales_channel,
               p.product_family,
               p.brand
          from (select *
                  from IFSAPP.SBL_JR_SALES_DTL_INV i
                union all
                select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
         inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
            on s.product_code = p.product_code) n
 where n.sales_price != 0
   and n.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and n.product_family = 'AIR-CONDITIONER'
 group by n.sales_channel, n.product_family, n.product_code
