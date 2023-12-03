declare
  cursor get_sales_price(price_list_no_  in varchar2,
                         catalog_no_     in varchar2,
                         specified_date_ in date) is
    select p.sales_price
      FROM ifsapp.SALES_PRICE_LIST_PART_TAB p
     inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                        lp.catalog_no,
                        min(abs(lp.valid_from_date - specified_date_)) diff
                   from IFSAPP.SALES_PRICE_LIST_PART_TAB lp
                  where lp.valid_from_date <= specified_date_
                  group by lp.price_list_no, lp.catalog_no
                  order by lp.catalog_no) m
        on p.price_list_no = m.price_list_no
       and p.catalog_no = m.catalog_no
     where abs(p.valid_from_date - specified_date_) = m.diff
       and p.price_list_no = price_list_no_
       and p.catalog_no = catalog_no_;

  price_list_no_  varchar2(10);
  catalog_no_     varchar2(25);
  specified_date_ date;
  sales_price     number;
begin
  price_list_no_ := '&price_list_no';
  catalog_no_ := '&product_code';
  specified_date_ := to_date('&specified_date', 'YYYY/MM/DD');

  open get_sales_price(price_list_no_, catalog_no_, specified_date_);
  fetch get_sales_price
    into sales_price;
  close get_sales_price;

  if sales_price is null then
    sales_price := 0;
  end if;

  dbms_output.put_line('sales_price is ' || sales_price);
END;
