select *
  from INVENTORY_TRANSACTION_HIST_TAB h
 where /*h.part_no = 'SRTV-SLD-24V10TC' 'SRREF-G-BCD-192'*/ --'SCBL-SB-3'
      /*and h.serial_no = 6578*/
      /*and h.contract = 'SISM'*/
   /*and*/ trunc(h.dated) between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and h.transaction_code in ('NISS' /*, 'NREC'*/)
/*and h.userid = 'EHSAN0665'*/
 order by h.dated
