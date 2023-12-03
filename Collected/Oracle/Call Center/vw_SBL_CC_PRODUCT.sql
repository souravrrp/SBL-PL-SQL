create or replace view SBL_CC_PRODUCT as
  select  IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Code('SCOM', s.catalog_no)) Brand,
          IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM', s.catalog_no)) sales_part_group,
          s.catalog_no sales_part_no,
          '' part_description,
          to_char(s.valid_from_date_1, 'YYYY/MM/DD') price_date,
          nvl(s.sales_price_1, 0) NSP,
          nvl(ifsapp.STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select p.cash_tax_code
                                                           from ifsapp.SALES_PRICE_LIST_PART p
                                                          where p.price_list_no = '1'
                                                            and p.valid_from_date <= sysdate
                                                            and p.valid_from_date = (select max(p1.valid_from_date)
                                                                                       from ifsapp.SALES_PRICE_LIST_PART p1
                                                                                      where p1.price_list_no = '1'
                                                                                        and p1.catalog_no = p.catalog_no) 
                                                              and p.catalog_no = s.catalog_no)), 0) VAT_RATE,
          nvl(round(((ifsapp.STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select p.cash_tax_code
                                                                  from ifsapp.SALES_PRICE_LIST_PART p
                                                                 where p.price_list_no = '1'
                                                                   and p.valid_from_date <= sysdate
                                                                   and p.valid_from_date = (select max(p1.valid_from_date)
                                                                                              from ifsapp.SALES_PRICE_LIST_PART p1
                                                                                             where p1.price_list_no = '1'
                                                                                               and p1.catalog_no = p.catalog_no)
                                                                   and p.catalog_no = s.catalog_no))) / 100) * s.sales_price_1, 2), 0) VAT,
          nvl(round(s.sales_price_1 + (((ifsapp.STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select p.cash_tax_code
                                                                                        from ifsapp.SALES_PRICE_LIST_PART p
                                                                                       where p.price_list_no = '1'
                                                                                         and p.valid_from_date <= sysdate
                                                                                         and p.valid_from_date = (select max(p1.valid_from_date)
                                                                                                                    from ifsapp.SALES_PRICE_LIST_PART p1
                                                                                                                   where p1.price_list_no = '1'
                                                                                                                     and p1.catalog_no = p.catalog_no)
                                                                                         and p.catalog_no = s.catalog_no))) / 100) * s.sales_price_1), 2), 0) RSP       
  from    ifsapp.SBL_LATEST_SALES_PRICE s
  where   IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM', s.catalog_no) not in ('ADORM', 'AVRML', 'SRCRM', 'RBOOK', 'S-AC', 'S-COM', 'S-CTV', 
            'S-DVD', 'S-GEN', 'S-IPS', 'S-MC', 'S-OTS', 'S-OVN', 'S-REF', 'S-SWM', 'S-WM', 'TR') 
   
