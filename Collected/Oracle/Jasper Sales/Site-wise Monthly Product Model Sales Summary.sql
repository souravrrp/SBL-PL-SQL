--***** Site-wise Monthly Product Model Sales Summary
select extract (year from n.sales_date) "YEAR",
       extract (month from n.sales_date) PERIOD,
       n.sales_channel,
       n.site,
       n.product_family,
       n.product_code,
       sum(n.sales_quantity) sales_quantity,
       sum(n.sales_price) revenue,
       sum(n.unit_nsp) total_unit_nsp,
       sum(n.vat) total_vat
  from (select s.*, -- National Sales
               case
                 when s.site = 'SCSM' then
                  'CORPORATE'
                 when s.site in ('JWSS', 'SAOS', 'SWSS', 'WSMO') then
                  'WHOLESALE'
                 when s.site in
                      ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') then
                  'STAFF_ONLINE_SCRAP'
                 else
                  'RETAIL'
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
 group by extract (year from n.sales_date), extract (month from n.sales_date), n.sales_channel, n.site, n.product_family, n.product_code
 order by extract (year from n.sales_date), extract (month from n.sales_date), n.sales_channel, n.site, n.product_family, n.product_code
