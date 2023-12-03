create or replace view SBL_LATEST_SALES_PRICE as
  select p.catalog_no,
         (select t.valid_from_date
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '1'
             and t.catalog_no = p.catalog_no) valid_from_date_1,
         (select t.sales_price
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '1'
             and t.catalog_no = p.catalog_no) sales_price_1,
         (select t.hp_sales_price
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '1'
             and t.catalog_no = p.catalog_no) hp_sales_price_1,
         (select t.valid_from_date
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '2'
             and t.catalog_no = p.catalog_no) valid_from_date_2,
         (select t.sales_price
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '2'
             and t.catalog_no = p.catalog_no) sales_price_2,
         (select t.hp_sales_price
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '2'
             and t.catalog_no = p.catalog_no) hp_sales_price_2,
         (select t.valid_from_date
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '3'
             and t.catalog_no = p.catalog_no) valid_from_date_3,
         (select t.sales_price
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '3'
             and t.catalog_no = p.catalog_no) sales_price_3,
         (select t.hp_sales_price
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '3'
             and t.catalog_no = p.catalog_no) hp_sales_price_3,
         (select t.valid_from_date
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '4'
             and t.catalog_no = p.catalog_no) valid_from_date_4,
         (select t.sales_price
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '4'
             and t.catalog_no = p.catalog_no) sales_price_4,
         (select t.hp_sales_price
            FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
           inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                             lp.catalog_no,
                             min(abs(lp.valid_from_date - trunc(sysdate))) diff
                        from IFSAPP.SALES_PRICE_LIST_PART lp
                       where lp.valid_from_date <= trunc(sysdate)
                       group by lp.price_list_no, lp.catalog_no) m
              on t.price_list_no = m.price_list_no
             and t.catalog_no = m.catalog_no
           where abs(t.valid_from_date - trunc(sysdate)) = m.diff
             and t.price_list_no = '4'
             and t.catalog_no = p.catalog_no) hp_sales_price_4
    from ifsapp.SALES_PRICE_LIST_PART p
   group by p.catalog_no
   order by 1
