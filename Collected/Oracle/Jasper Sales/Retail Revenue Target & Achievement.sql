--*****Retail Revenue Target & Achievement (Shopwise)
select s.area_code,
       s.district_code,
       s.shop_code,
       nvl(t.target_revenue, 0) target_revenue,
       nvl(a.achievement, 0) achievement,
       decode(nvl(t.target_revenue, 0),
              0,
              0,
              round((nvl(a.achievement, 0) / nvl(t.target_revenue, 0) * 100),
                    2)) achiev_prcntg
  from IFSAPP.SHOP_DTS_INFO s
  left join (select r.shop_code, sum(r.revenue) target_revenue
               from IFSAPP.SBL_JR_RST_REVENUE_TGT r
              where r.year = '&YEAR'
                and r.period between '&START_PERIOD' and '&END_PERIOD'
              group by r.shop_code) t
    on s.shop_code = t.shop_code
  left join (select m.site,
                    (nvl(m.achievement, 0) + nvl(n.achievement, 0)) achievement
               from (select i.site, sum(i.sales_price) achievement
                       from IFSAPP.SBL_JR_SALES_DTL_INV i
                      where extract(year from i.sales_date) = '&YEAR'
                        and extract(month from i.sales_date) between
                            '&START_PERIOD' and '&END_PERIOD'
                      group by i.site) m
               left join (select p.site, sum(p.sales_price) achievement
                           from IFSAPP.SBL_JR_SALES_DTL_PKG p
                          where extract(year from p.sales_date) = '&YEAR'
                            and extract(month from p.sales_date) between
                                '&START_PERIOD' and '&END_PERIOD'
                          group by p.site) n
                 on m.site = n.site) a
    on s.shop_code = a.site
 where s.district_code != 40
 order by to_number(s.district_code), s.shop_code

--*****Retail Revenue Target & Achievement (District-wise)
select s.area_code,
       s.district_code,
       nvl(sum(t.target_revenue), 0) target_revenue,
       nvl(sum(a.achievement), 0) achievement,
       decode(nvl(sum(t.target_revenue), 0),
              0,
              0,
              round((nvl(sum(a.achievement), 0) / nvl(sum(t.target_revenue), 0) * 100),
                    2)) achiev_prcntg
  from IFSAPP.SHOP_DTS_INFO s
  left join (select r.shop_code, sum(r.revenue) target_revenue
               from IFSAPP.SBL_JR_RST_REVENUE_TGT r
              where r.year = '&YEAR'
                and r.period between '&START_PERIOD' and '&END_PERIOD'
              group by r.shop_code) t
    on s.shop_code = t.shop_code
  left join (select m.site,
                    (nvl(m.achievement, 0) + nvl(n.achievement, 0)) achievement
               from (select i.site, sum(i.sales_price) achievement
                       from IFSAPP.SBL_JR_SALES_DTL_INV i
                      where extract(year from i.sales_date) = '&YEAR'
                        and extract(month from i.sales_date) between
                            '&START_PERIOD' and '&END_PERIOD'
                      group by i.site) m
               left join (select p.site, sum(p.sales_price) achievement
                           from IFSAPP.SBL_JR_SALES_DTL_PKG p
                          where extract(year from p.sales_date) = '&YEAR'
                            and extract(month from p.sales_date) between
                                '&START_PERIOD' and '&END_PERIOD'
                          group by p.site) n
                 on m.site = n.site) a
    on s.shop_code = a.site
 where s.district_code != 40
 group by s.area_code, s.district_code
 order by to_number(s.district_code)

--*****Retail Revenue Target & Achievement (Area-wise)
select s.area_code,
       nvl(sum(t.target_revenue), 0) target_revenue,
       nvl(sum(a.achievement), 0) achievement,
       decode(nvl(sum(t.target_revenue), 0),
              0,
              0,
              round((nvl(sum(a.achievement), 0) / nvl(sum(t.target_revenue), 0) * 100),
                    2)) achiev_prcntg
  from IFSAPP.SHOP_DTS_INFO s
  left join (select r.shop_code, sum(r.revenue) target_revenue
               from IFSAPP.SBL_JR_RST_REVENUE_TGT r
              where r.year = '&YEAR'
                and r.period between '&START_PERIOD' and '&END_PERIOD'
              group by r.shop_code) t
    on s.shop_code = t.shop_code
  left join (select m.site,
                    (nvl(m.achievement, 0) + nvl(n.achievement, 0)) achievement
               from (select i.site, sum(i.sales_price) achievement
                       from IFSAPP.SBL_JR_SALES_DTL_INV i
                      where extract(year from i.sales_date) = '&YEAR'
                        and extract(month from i.sales_date) between
                            '&START_PERIOD' and '&END_PERIOD'
                      group by i.site) m
               left join (select p.site, sum(p.sales_price) achievement
                           from IFSAPP.SBL_JR_SALES_DTL_PKG p
                          where extract(year from p.sales_date) = '&YEAR'
                            and extract(month from p.sales_date) between
                                '&START_PERIOD' and '&END_PERIOD'
                          group by p.site) n
                 on m.site = n.site) a
    on s.shop_code = a.site
 where s.district_code != 40
 group by s.area_code
 order by s.area_code
