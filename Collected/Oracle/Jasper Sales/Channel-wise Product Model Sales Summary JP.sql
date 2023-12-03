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
                 when s.site in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM') then
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
   and n.sales_date between $P{FROM_DATE} and $P{TO_DATE} 
 	 and $X{IN, n.product_family, PRODUCT_FAMILY}
	 and $X{IN, n.product_code, PART_NO}
 group by n.sales_channel, n.product_family, n.product_code
