--*****************Sales Data
select v_sl.year,
       v_sl.period,
       v_sl.shop_code,
       (select s.area_code
          from shop_dts_info s
         where s.shop_code = v_sl.shop_code) area_code,
       (select s.district_code
          from shop_dts_info s
         where s.shop_code = v_sl.shop_code) district_code,
       v_sl.item,
       sum(v_sl.amount) amount
  from (select extract(year from i.invoice_date) "YEAR",
               extract(month from i.invoice_date) PERIOD,
               t.c10 shop_code,
               'sales_value' item,
               t.net_curr_amount amount
          from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
         where t.invoice_id = i.invoice_id
           and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           and t.rowstate = 'Posted'
           and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
               ('INV', 'PKG', 'NON')
           and t.c10 not in ('BLSP',
                             'BSCP',
                             'CSCP',
                             'CLSP',
                             'CXSP',
                             'DSCP',
                             'FSCP', --New Service Center
                             'JSCP',
                             'KSCP',
                             'MSCP',
                             'NSCP',
                             'RSCP',
                             'RPSP',
                             'SSCP',
                             'MS1C',
                             'MS2C',
                             'BTSC',
                             'JWSS',
                             'SAPM',
                             'SAOS',
                             'SCOM',
                             'SCSM',
                             'SESM',
                             'SHOM',
                             'SISM',
                             'SOSM',
                             'SWSS',
                             'WSMO',
                             'SITM',
                             'SSAM',
                             'WITM')
           and i.invoice_date between
               to_date('&year_i' || '/' || '&start_period' || '/1',
                       'YYYY/MM/DD') and
               last_day(to_date('&year_i' || '/' || '&end_period' || '/1',
                                'YYYY/MM/DD'))) v_sl
 group by v_sl.year, v_sl.period, v_sl.shop_code, v_sl.item

union

--*****************Shopwise BE Expenses Summary
select v_be.year,
       v_be.period,
       v_be.contract,
       (select s.area_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) area_code,
       (select s.district_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) district_code,
       v_be.rsl_item item,
       sum(v_be.amount) amount
  from --***************BE Expenses List
        (select extract(year from r.from_date) year,
                extract(month from r.from_date) period,
                r.contract,
                i.rsl_item_description rsl_item,
                i.amount
           from HPNRET_RSL_ITEM i, HPNRET_RSL r
          where r.company = i.company
            and r.contract = i.contract
            and r.sequence_no = i.sequence_no
            and substr(r.sequence_no, 4, 3) = 'RSL'
            and i.rsl_item_type_db = 'EXPENSE'
            and i.rsl_item_id like 'BE%'
            and i.amount > 0
            and r.from_date >= to_date('&year_i' || '/' || '&start_period' || '/1',
                                       'YYYY/MM/DD')
            and r.to_date <=
                last_day(to_date('&year_i' || '/' || '&end_period' || '/1',
                                 'YYYY/MM/DD'))) v_be
 group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

union

--*****************Shopwise BA Expenses Summary
select v_be.year,
       v_be.period,
       v_be.contract,
       (select s.area_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) area_code,
       (select s.district_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) district_code,
       v_be.rsl_item item,
       sum(v_be.amount) amount
  from --***************BA Expenses List
        (select extract(year from r.from_date) year,
                extract(month from r.from_date) period,
                r.contract,
                i.rsl_item_description rsl_item,
                i.amount
           from HPNRET_RSL_ITEM i, HPNRET_RSL r
          where r.company = i.company
            and r.contract = i.contract
            and r.sequence_no = i.sequence_no
            and substr(r.sequence_no, 4, 3) = 'RSL'
            and i.rsl_item_type_db = 'EXPENSE'
            and i.rsl_item_id like 'BA%'
            and i.amount > 0
            and r.from_date >= to_date('&year_i' || '/' || '&start_period' || '/1',
                                       'YYYY/MM/DD')
            and r.to_date <=
                last_day(to_date('&year_i' || '/' || '&end_period' || '/1',
                                 'YYYY/MM/DD'))) v_be
 group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

union

--*****************Shopwise BI Expenses Summary
select v_be.year,
       v_be.period,
       v_be.contract,
       (select s.area_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) area_code,
       (select s.district_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) district_code,
       v_be.rsl_item item,
       sum(v_be.amount) amount
  from --**************BI Expenses List
        (select extract(year from r.from_date) year,
                extract(month from r.from_date) period,
                r.contract,
                i.rsl_item_description rsl_item,
                i.amount
           from HPNRET_RSL_ITEM i, HPNRET_RSL r
          where r.company = i.company
            and r.contract = i.contract
            and r.sequence_no = i.sequence_no
            and substr(r.sequence_no, 4, 3) = 'RSL'
            and i.rsl_item_type_db = 'RECEIPT'
            and i.rsl_item_id like 'BI%'
            and i.amount > 0
            and r.from_date >= to_date('&year_i' || '/' || '&start_period' || '/1',
                                       'YYYY/MM/DD')
            and r.to_date <=
                last_day(to_date('&year_i' || '/' || '&end_period' || '/1',
                                 'YYYY/MM/DD'))) v_be
 group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

union

--*****************Shopwise BL Expenses Summary
select v_be.year,
       v_be.period,
       v_be.contract,
       (select s.area_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) area_code,
       (select s.district_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) district_code,
       v_be.rsl_item item,
       sum(v_be.amount) amount
  from --***************BL Expenses List
        (select extract(year from r.from_date) year,
                extract(month from r.from_date) period,
                r.contract,
                i.rsl_item_description rsl_item,
                i.amount
           from HPNRET_RSL_ITEM i, HPNRET_RSL r
          where r.company = i.company
            and r.contract = i.contract
            and r.sequence_no = i.sequence_no
            and substr(r.sequence_no, 4, 3) = 'RSL'
            and i.rsl_item_type_db = 'RECEIPT'
            and i.rsl_item_id like 'BL%'
            and i.amount > 0
            and r.from_date >= to_date('&year_i' || '/' || '&start_period' || '/1',
                                       'YYYY/MM/DD')
            and r.to_date <=
                last_day(to_date('&year_i' || '/' || '&end_period' || '/1',
                                 'YYYY/MM/DD'))) v_be
 group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

union

--*****************Shopwise Service Charge Summary
select v_be.year,
       v_be.period,
       v_be.contract,
       (select s.area_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) area_code,
       (select s.district_code
          from shop_dts_info s
         where s.shop_code = v_be.contract) district_code,
       v_be.rsl_item item,
       sum(v_be.amount) amount
  from --***************Service Charge List
        (select extract(year from r.from_date) year,
                extract(month from r.from_date) period,
                r.contract,
                i.rsl_item_description rsl_item,
                i.amount
           from HPNRET_RSL_ITEM i, HPNRET_RSL r
          where r.company = i.company
            and r.contract = i.contract
            and r.sequence_no = i.sequence_no
            and substr(r.sequence_no, 4, 3) = 'RSL'
            and i.rsl_item_description = 'Service Charge'
            and i.amount > 0
            and r.from_date >= to_date('&year_i' || '/' || '&start_period' || '/1',
                                       'YYYY/MM/DD')
            and r.to_date <=
                last_day(to_date('&year_i' || '/' || '&end_period' || '/1',
                                 'YYYY/MM/DD'))) v_be
 group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

--order by year, period, contract, item,
