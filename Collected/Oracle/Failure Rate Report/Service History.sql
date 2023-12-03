--***** Service History
select s.*,
       substr(s.mch_code, 1, instr(s.mch_code, '-', -3, 1) - 1) part_no,
       substr(s.mch_code, instr(s.mch_code, '-', -3, 1) + 1) serial_no,
       (select i.receipt_date
          from IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
         where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                             i.vendor_no,
                                                             'Supplier') = '0'
           and i.part_no =
               substr(s.mch_code, 1, instr(s.mch_code, '-', -3, 1) - 1)
           and i.serial_no =
               substr(s.mch_code, instr(s.mch_code, '-', -3, 1) + 1)) receipt_date,
       round(decode((select i.receipt_date
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
                                  instr(s.mch_code, '-', -3, 1) + 1)),
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
                                                  instr(s.mch_code, '-', -3, 1) - 1)
                                       and i.serial_no =
                                           substr(s.mch_code,
                                                  instr(s.mch_code, '-', -3, 1) + 1))))) service_month
  from (select a.wo_no, a.mch_code, a.mch_code_description, a.reg_date
          from IFSAPP.ACTIVE_SEPARATE a
        union all
        select h.wo_no, h.mch_code, h.mch_code_description, h.reg_date
          from IFSAPP.HISTORICAL_SEPARATE h) s
 where substr(s.mch_code, 1, instr(s.mch_code, '-', -3, 1) - 1) =
       'SRTV-SLE32E3HDTV'
   and trunc((select i.receipt_date
               from IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
              where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                                  i.vendor_no,
                                                                  'Supplier') = '0'
                and i.part_no =
                    substr(s.mch_code, 1, instr(s.mch_code, '-', -3, 1) - 1)
                and i.serial_no =
                    substr(s.mch_code, instr(s.mch_code, '-', -3, 1) + 1))) between
       to_date('2018/1/1', 'YYYY/MM/DD') and
       to_date('2018/2/28', 'YYYY/MM/DD')
