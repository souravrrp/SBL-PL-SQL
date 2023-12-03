--*****Latest Sales Price of all Price list
select 
    distinct(p.catalog_no) catalog_no,
    (select t.valid_from_date
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '1' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '1')) valid_from_date_1,
    (select t.sales_price
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '1' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '1')) sale_price_1,
    (select t.hp_sales_price
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '1' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '1')) hp_sale_price_1,
    (select t.valid_from_date
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '2' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '2')) valid_from_date_2,
    (select t.sales_price
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '2' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '2')) sale_price_2,
    (select t.hp_sales_price
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '2' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '2')) hp_sale_price_2,
    (select t.valid_from_date
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '3' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '3')) valid_from_date_3,
    (select t.sales_price
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '3' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '3')) sale_price_3,
    (select t.hp_sales_price
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '3' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '3')) hp_sale_price_3,
    (select t.valid_from_date
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '4' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '4')) valid_from_date_4,
    (select t.sales_price
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '4' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '4')) sale_price_4,
    (select t.hp_sales_price
      from SALES_PRICE_LIST_PART t
      where 
        t.catalog_no = p.catalog_no and
        t.price_list_no = '4' and
        t.valid_from_date <= sysdate and
        t.valid_from_date = (select max(t.valid_from_date) 
                              from SALES_PRICE_LIST_PART t where t.catalog_no = p.catalog_no and t.price_list_no = '4')) hp_sale_price_4
from SALES_PRICE_LIST_PART p
where p.catalog_no like '&catalog_no'


--*****Price of a specific price list and catalog no
select 
    --*
    t.price_list_no,
    t.catalog_no,
    t.valid_from_date,
    t.sales_price,
    t.hp_sales_price
from SALES_PRICE_LIST_PART t
where 
  t.catalog_no like '&catalog_no' and
  t.price_list_no like '&price_list_no' and
  t.valid_from_date <= sysdate and
  t.valid_from_date = (select max(t.valid_from_date) 
                        from SALES_PRICE_LIST_PART t where t.catalog_no like '&catalog_no' and t.price_list_no like '&price_list_no')


--*****
/*select 
    v.catalog_no,
    (select * from 
      (select p1.sales_price from SALES_PRICE_LIST_PART p1 
      where p1.price_list_no = '1' and p1.catalog_no = v.catalog_no and p1.valid_from_date <= sysdate
      order by p1.valid_from_date desc) v1
    where rownum <= 1) sales_price_1
from (select distinct(p.catalog_no) catalog_no from SALES_PRICE_LIST_PART p) v
where v.catalog_no = 'SGTV-UA32EH4003RSER'*/
