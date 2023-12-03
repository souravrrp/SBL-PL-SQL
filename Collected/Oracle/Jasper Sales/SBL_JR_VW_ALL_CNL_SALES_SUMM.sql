CREATE OR REPLACE VIEW SBL_JR_VW_ALL_CNL_SALES_SUMM AS
-- National Sales (All Channel)
select l.sales_date, l.sales_channel, sum(l.sales_price) sales_price
  from (select s.sales_date,
               s.site,
               case
                 when s.site in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'WITM') then
                  'WHOLESALE'
                 when s.site = 'SCSM' then
                  'CORPORATE'
                 when s.site = 'SITM' then
                  'IT CHANNEL'
                 when s.site = 'SSAM' then
                  'SMALL APPLIANCE CHANNEL'
                 when s.site = 'SOSM' then
                  'ONLINE CHANNEL'
                 when s.site in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM') then
                  'STAFF SCRAP & ACQUISITION'
                 when s.site in (select s.site
                                   from ifsapp.shop_dts_info t
                                  where t.shop_code = s.site) then
                  'RETAIL'
                 else
                  'BLANK'
               end sales_channel,
               s.sales_price
          from (select *
                  from IFSAPP.SBL_JR_SALES_DTL_INV i
                union all
                select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s) l
 where l.sales_channel != 'BLANK'
 group by l.sales_date, l.sales_channel
 order by l.sales_date, l.sales_channel