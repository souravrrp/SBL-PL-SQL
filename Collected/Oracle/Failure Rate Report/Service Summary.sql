select g.year,
       g.period,
       g.part_no,
       g.service_month,
       nvl(h.no_of_failures, 0) no_of_failures
  from (select j.*, k.*, 'SRTV-SLE32E3HDTV' part_no
          from (select extract(year from add_months(start_date, level - 1)) "YEAR",
                       extract(month from add_months(start_date, level - 1)) period
                  from (select date '2018-01-01' start_date,
                               date '2018-02-28' end_date
                          from dual)
                connect by level <=
                           months_between(trunc(end_date, 'MM'),
                                          trunc(start_date, 'MM')) + 1) j
         cross join (select rownum - 1 service_month
                      from dual d
                    connect by rownum <= 17) k) g
 left join ( --***** Service Summary
             select extract(year from f.receipt_date) "YEAR",
                     extract(month from f.receipt_date) period,
                     f.part_no,
                     f.service_month,
                     count(f.wo_no) no_of_failures
               from (select s.*,
                             substr(s.mch_code,
                                    1,
                                    instr(s.mch_code, '-', -3, 1) - 1) part_no,
                             substr(s.mch_code,
                                    instr(s.mch_code, '-', -3, 1) + 1) serial_no,
                             (select i.receipt_date
                                from IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
                               where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                                                   i.vendor_no,
                                                                                   'Supplier') = '0'
                                 and i.part_no =
                                     substr(s.mch_code,
                                            1,
                                            instr(s.mch_code, '-', -3, 1) - 1)
                                 and i.serial_no =
                                     substr(s.mch_code,
                                            instr(s.mch_code, '-', -3, 1) + 1)) receipt_date,
                             round(decode((select i.receipt_date
                                            from IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
                                           where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                                                               i.vendor_no,
                                                                                               'Supplier') = '0'
                                             and i.part_no =
                                                 substr(s.mch_code,
                                                        1,
                                                        instr(s.mch_code,
                                                              '-',
                                                              -3,
                                                              1) - 1)
                                             and i.serial_no =
                                                 substr(s.mch_code,
                                                        instr(s.mch_code,
                                                              '-',
                                                              -3,
                                                              1) + 1)),
                                          null,
                                          0,
                                          months_between(s.reg_date,
                                                         (select i.receipt_date
                                                            from IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
                                                           where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                                                                               i.vendor_no,
                                                                                                               'Supplier') = '0'
                                                             and i.part_no =
                                                                 substr(s.mch_code,
                                                                        1,
                                                                        instr(s.mch_code,
                                                                              '-',
                                                                              -3,
                                                                              1) - 1)
                                                             and i.serial_no =
                                                                 substr(s.mch_code,
                                                                        instr(s.mch_code,
                                                                              '-',
                                                                              -3,
                                                                              1) + 1))))) service_month
                        from (select a.wo_no,
                                     a.mch_code,
                                     a.mch_code_description,
                                     a.reg_date
                                from IFSAPP.ACTIVE_SEPARATE a
                              union all
                              select h.wo_no,
                                     h.mch_code,
                                     h.mch_code_description,
                                     h.reg_date
                                from IFSAPP.HISTORICAL_SEPARATE h) s
                       where substr(s.mch_code,
                                    1,
                                    instr(s.mch_code, '-', -3, 1) - 1) =
                             'SRTV-SLE32E3HDTV'
                         and trunc((select i.receipt_date
                                     from IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
                                    where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                                                        i.vendor_no,
                                                                                        'Supplier') = '0'
                                      and i.part_no =
                                          substr(s.mch_code,
                                                 1,
                                                 instr(s.mch_code, '-', -3, 1) - 1)
                                      and i.serial_no =
                                          substr(s.mch_code,
                                                 instr(s.mch_code, '-', -3, 1) + 1))) between
                             to_date('2018/1/1', 'YYYY/MM/DD') and
                             to_date('2018/2/28', 'YYYY/MM/DD')) f
              where f.service_month <= 16
              group by extract(year from f.receipt_date),
                        extract(month from f.receipt_date),
                        f.part_no,
                        f.service_month
             /*order by f.service_month*/
             ) h
    on g.year = h.year
   and g.period = h.period
   and g.part_no = h.part_no
   and g.service_month = h.service_month
 order by g.year, g.period, g.part_no, g.service_month
