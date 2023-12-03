--National Weekly Sales
select to_char(s.sales_date - 7 / 24, 'IYYY') "YEAR",
       to_char(s.sales_date - 7 / 24, 'IW') WEEK,
       sum(s.sales_quantity) sales_quantity,
       sum(s.sales_price) sales_price
  from (select i.*
          from IFSAPP.SBL_JR_SALES_DTL_INV i
         where i.sales_price != 0
           and i.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
               to_date('&to_date', 'YYYY/MM/DD')
        
        union all
        
        select *
          from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c
         where c.sales_price != 0
           and c.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
               to_date('&to_date', 'YYYY/MM/DD')) s
 group by to_char(s.sales_date - 7 / 24, 'IYYY'),
          to_char(s.sales_date - 7 / 24, 'IW')
 order by to_number(to_char(s.sales_date - 7 / 24, 'IYYY')),
          to_number(to_char(s.sales_date - 7 / 24, 'IW'));

--Retail Weekly Sales 
select to_char(s.sales_date - 7 / 24, 'IYYY') "YEAR",
       to_char(s.sales_date - 7 / 24, 'IW') WEEK,
       sum(s.sales_quantity) sales_quantity,
       sum(s.sales_price) sales_price
  from (select i.*
          from IFSAPP.SBL_JR_SALES_DTL_INV i
         where i.sales_price != 0
           and i.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
               to_date('&to_date', 'YYYY/MM/DD')
        
        union all
        
        select *
          from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c
         where c.sales_price != 0
           and c.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
               to_date('&to_date', 'YYYY/MM/DD')) s
 where s.site not in ('BSCP', --Service Sites
                      'BLSP',
                      'CLSP',
                      'CSCP',
                      'CXSP', --New Service Center
                      'DSCP',
                      'JSCP',
                      'MSCP',
                      'RPSP', --New Service Center
                      'RSCP',
                      'SSCP',
                      'MS1C',
                      'MS2C',
                      'BTSC',
                      'JWSS', --Wholesale Sites
                      'SAOS',
                      'SWSS',
                      'WSMO',
                      'SAPM', --Corporate, Employee, & Scrap Sites
                      'SCSM',
                      'SESM',
                      'SHOM',
                      'SISM',
                      'SFSM',
                      'SOSM')
 group by to_char(s.sales_date - 7 / 24, 'IYYY'),
          to_char(s.sales_date - 7 / 24, 'IW')
 order by to_number(to_char(s.sales_date - 7 / 24, 'IYYY')),
          to_number(to_char(s.sales_date - 7 / 24, 'IW'));
