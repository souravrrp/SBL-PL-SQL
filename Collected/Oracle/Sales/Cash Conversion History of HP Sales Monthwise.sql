--Cash Conversion History of HP Sales Monthwise
select '&year_i' "YEAR",
       '&period' "PERIOD",
       extract(year from h1.entered_date) cc_year,
       extract(month from h1.entered_date) cc_period,
       count(distinct(t.c1)) TOTAL_CC_LATER,
       sum(t.net_curr_amount) TOTAL_LATER_CC_AMOUNT
  from ifsapp.invoice_item_tab t
 inner join ifsapp.INVOICE_TAB i
    on t.invoice_id = i.invoice_id
 inner join (select h.contract,
                    h.account_no,
                    h.line_no,
                    h.status,
                    h.entered_date
               from ifsapp.HPNRET_HP_LINE_HISTORY_TAB h
              where h.status = 'CashConverted') h1
    on t.c1 = h1.account_no
   and t.c2 = h1.line_no
 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG' /*, 'NON'*/)
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'DSCP',
                     'JSCP',
                     'MSCP', --New Service Center
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC')
   and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
   and t.c10 not in
       ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   and i.invoice_date between
       to_date('&year_i' || '/' || '&period' || '/1', 'yyyy/mm/dd') and
       last_day(to_date('&year_i' || '/' || '&period' || '/1', 'yyyy/mm/dd'))
   and t.net_curr_amount > 0
   and substr(t.c1, 4, 2) = '-H'
 group by extract(year from h1.entered_date),
          extract(month from h1.entered_date)
 order by 3, 4
