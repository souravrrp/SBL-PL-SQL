select *
  from IFSAPP.INVENTORY_PART i
 where i.create_date >= to_date('2015/10/1', 'YYYY/MM/DD')
   and i.contract = 'SCOM'
   and i.second_commodity not like 'S-%'
   and (i.part_no not like 'SRACS-%' and i.part_no not like 'RMAV-%')
 order by i.create_date, i.part_no
