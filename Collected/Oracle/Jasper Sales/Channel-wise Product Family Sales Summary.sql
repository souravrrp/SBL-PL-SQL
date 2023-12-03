--***** Channel-wise Product Family Sales Summary
select /*l.sales_date,*/
       l.sales_channel,
       l.product_family,
       sum(l.sales_quantity) sales_unit,
       sum(l.sales_price) sales_value
  from (select s.sales_date,
               s.site,
               case
                 when s.site in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM') then
                  'WHOLESALE'
                 when s.site = 'SCSM' then
                  'CORPORATE'
                 when s.site in (select s.site
                                   from ifsapp.shop_dts_info t
                                  where t.shop_code = s.site) then
                  'RETAIL'
                 else
                  'OTHERS'
               end sales_channel,
               p.product_family,
               s.product_code,
               s.sales_quantity,
               s.sales_price
          from (select *
                  from IFSAPP.SBL_JR_SALES_DTL_INV i
                union all
                select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
         inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
            on s.product_code = p.product_code) l
 where l.sales_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD')
 group by /*l.sales_date,*/ l.sales_channel, l.product_family
 order by /*l.sales_date,*/ l.sales_channel, l.product_family
