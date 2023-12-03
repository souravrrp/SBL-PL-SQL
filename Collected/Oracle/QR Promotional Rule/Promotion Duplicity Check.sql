--***** Promotion Duplicity Check (Discount) Detail
select t.*
  from ifsapp.SBL_DISCOUNT_PROMOTION t
 where T.valid_to >= to_date('&from_date', 'yyyy/mm/dd')
   and T.valid_from <= to_date('&to_date', 'yyyy/mm/dd')
   and T.transaction_no = 1 -- 1 -> HP, 2 -> Cash
   and T.channel in ('ALL', '24'/*, '736', '762', '1142'*/)
   and t.part_no in
       (select T.part_no
          from ifsapp.SBL_DISCOUNT_PROMOTION t
         WHERE T.valid_to >= to_date('&from_date', 'yyyy/mm/dd')
           and T.valid_from <= to_date('&to_date', 'yyyy/mm/dd')
           and T.transaction_no = 1 -- 1 -> HP, 2 -> Cash
           and T.channel in ('ALL', '24' /*, '736', '762', '1142'*/)
         GROUP BY T.part_no
        HAVING COUNT(*) > 1)
 /*group by t.valid_from, t.valid_to*/
 order by t.part_no, t.valid_from, t.valid_to
