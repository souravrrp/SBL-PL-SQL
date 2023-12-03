--***** Gift Voucher Status
select s.ordered_site "SITE",
       s.part_no,
       s.state,
       count(s.sheet_serial_no) no_of_sheets
  from ifsapp.PURINV_SHEET_REGISTER_SHEET s
 where s.book_types = 'GV'
   and s.ordered_site like '&SITE'
   and s.state = 'Issued' /*'Unused'*/
   /*and s.part_no like 'SRGV-%'*/
 group by s.ordered_site, s.part_no, s.state
 order by s.ordered_site, s.part_no, s.state
