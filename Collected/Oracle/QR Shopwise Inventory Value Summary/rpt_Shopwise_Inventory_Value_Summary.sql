select t.stat_year,
       t.stat_period_no,
       t.contract,
       sum(t.bf_balance) total_bf_balance,
       sum((select w.SALES_PRICE SALE_PRICE_NSP
             FROM ifsapp.SALES_PRICE_LIST_PART_TAB w
            where w.PRICE_LIST_NO = '1'
              and w.catalog_no = t.part_no
              and w.valid_from_date <= sysdate
              and w.VALID_FROM_DATE =
                  (select max(s.VALID_FROM_DATE)
                     from ifsapp.SALES_PRICE_LIST_PART_TAB s
                    where s.CATALOG_NO = w.CATALOG_NO
                      and s.PRICE_LIST_NO = '1'))) TOTAL_SALE_PRICE_NSP,
       sum(t.bf_balance *
           (select w.SALES_PRICE SALE_PRICE_NSP
              FROM ifsapp.SALES_PRICE_LIST_PART_TAB w
             where w.PRICE_LIST_NO = '1'
               and w.catalog_no = t.part_no
               and w.valid_from_date <= sysdate
               and w.VALID_FROM_DATE =
                   (select max(s.VALID_FROM_DATE)
                      from ifsapp.SALES_PRICE_LIST_PART_TAB s
                     where s.CATALOG_NO = w.CATALOG_NO
                       and s.PRICE_LIST_NO = '1'))) TOTAL_SALE_PRICE_NSP
  from ifsapp.REP246_TAB t
 where t.stat_year = '&year_i'
   and t.stat_period_no = '&period'
   and t.contract like '&shop_code'
 group by t.stat_year, t.stat_period_no, t.contract
