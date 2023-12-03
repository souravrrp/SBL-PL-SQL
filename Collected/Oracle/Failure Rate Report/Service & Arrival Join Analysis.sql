--***** Service & Arrival Join Analysis
select s.*, n.serial_no, n.receipt_date
  from (select a.wo_no,
               a.contract,
               a.mch_code,
               a.mch_code_description,
               substr(a.mch_code, 1, instr(a.mch_code, '-', -1, 1) - 1) part_no,
               substr(a.mch_code, instr(a.mch_code, '-', -1, 1) + 1) serial_no,
               IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(substr(a.mch_code,
                                                            1,
                                                            instr(a.mch_code,
                                                                  '-',
                                                                  -1,
                                                                  1) - 1),
                                                     substr(a.mch_code,
                                                            instr(a.mch_code,
                                                                  '-',
                                                                  -1,
                                                                  1) + 1)) oem_no,
               a.reg_date
          from IFSAPP.ACTIVE_SEPARATE a
        union all
        select h.wo_no,
               h.CONTRACT,
               h.mch_code,
               h.mch_code_description,
               substr(h.mch_code, 1, instr(h.mch_code, '-', -1, 1) - 1) part_no,
               substr(h.mch_code, instr(h.mch_code, '-', -1, 1) + 1) serial_no,
               IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(substr(h.mch_code,
                                                            1,
                                                            instr(h.mch_code,
                                                                  '-',
                                                                  -1,
                                                                  1) - 1),
                                                     substr(h.mch_code,
                                                            instr(h.mch_code,
                                                                  '-',
                                                                  -1,
                                                                  1) + 1)) oem_no,
               h.reg_date
          from IFSAPP.HISTORICAL_SEPARATE h) s
 inner join (select i.part_no,
                    i.contract,
                    i.serial_no,
                    IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(i.part_no,
                                                          i.serial_no) oem_no,
                    trunc(i.receipt_date) receipt_date
               from IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
              where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                                  i.vendor_no,
                                                                  'Supplier') = '0'
                and i.part_no = 'SRTV-SLE32E3HDTV'
                and trunc(i.receipt_date) between
                    to_date('2017/12/26', 'YYYY/MM/DD') and
                    to_date('2019/10/31', 'YYYY/MM/DD')) n
    on s.part_no = n.part_no
   and s.oem_no = n.oem_no
 /*where s.serial_no != n.serial_no*/
