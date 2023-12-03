--***** Service Details
select *
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
          from IFSAPP.HISTORICAL_SEPARATE h) b
 where b.part_no = 'SRTV-SLE32E3HDTV'
   and trunc(b.reg_date) between to_date('2017/12/26', 'YYYY/MM/DD') and
       to_date('2019/10/31', 'YYYY/MM/DD')
