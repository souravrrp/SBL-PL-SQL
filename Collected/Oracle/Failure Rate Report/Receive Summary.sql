select g.year, g.period, g.part_no, nvl(l.qtn, 0) qtn
  from (select j.*, /*k.*,*/ 'SRTV-SLE32E3HDTV' part_no
          from (select extract(year from add_months(start_date, level - 1)) "YEAR",
                       extract(month from add_months(start_date, level - 1)) period
                  from (select date '2018-01-01' start_date,
                               date '2018-02-28' end_date
                          from dual)
                connect by level <=
                           months_between(trunc(end_date, 'MM'),
                                          trunc(start_date, 'MM')) + 1) j
        /*cross join (select rownum - 1 service_month
          from dual d
        connect by rownum <= 17) k*/
        ) g
  left join ( --***** Receive Summary
             select extract(year from r.receipt_date) "YEAR",
                     extract(month from r.receipt_date) period,
                     r.part_no,
                     count(r.serial_no) qtn
               from (select i.part_no,
                             i.serial_no,
                             IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(i.part_no,
                                                                   i.serial_no) oem_no,
                             i.part_no || '-' || i.serial_no mch_code,
                             i.vendor_no,
                             IFSAPP.SUPPLIER_INFO_API.Get_Name(i.vendor_no) vendor_name,
                             i.receipt_date
                        from IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
                       where i.part_no = 'SRTV-SLE32E3HDTV'
                         and IFSAPP.PART_CATALOG_API.Get_Serial_Tracking_Code_Db(i.part_no) =
                             'SERIAL TRACKING'
                         and IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                                           i.vendor_no,
                                                                           'Supplier') = '0'
                         and trunc(i.receipt_date) between
                             to_date('2018/1/1', 'YYYY/MM/DD') and
                             to_date('2018/2/28', 'YYYY/MM/DD')) r
              group by extract(year from r.receipt_date),
                        extract(month from r.receipt_date),
                        r.part_no,
                        r.vendor_no) l
    on g.year = l.year
   and g.period = l.period
   and g.part_no = l.part_no
