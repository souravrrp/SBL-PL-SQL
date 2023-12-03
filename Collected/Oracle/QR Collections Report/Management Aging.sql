select i.contract shop_code,
       (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = i.contract) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = i.contract) district_code,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(i.contract,
                                                                                                         i.part_no)) brand,
       ifsapp.inventory_part_api.Get_Part_Product_Family(i.contract,
                                                         i.part_no) product_family,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(i.contract,
                                                                                                             i.part_no)) product_family_description,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(ifsapp.inventory_part_api.Get_Second_Commodity(i.contract,
                                                                                                 i.part_no)) comm_group_2,
       IFSAPP.PART_CATALOG_API.Get_Serial_Tracking_Code(i.part_no) Serial_Tracking_Code,
       i.part_no,
       i.serial_no,
       ifsapp.SERIAL_OEM_CONN_API.Get_Oem_No(i.part_no, i.serial_no) Oem_No,
       i.qty_onhand,
       trunc(i.receipt_date) receipt_date,
       trunc(sysdate) - trunc(i.receipt_date) shop_age,
       case
         when trunc(sysdate) - trunc(i.receipt_date) <= 90 then
          '03'
         when trunc(sysdate) - trunc(i.receipt_date) <= 180 then
          '06'
         when trunc(sysdate) - trunc(i.receipt_date) <= 270 then
          '09'
         when trunc(sysdate) - trunc(i.receipt_date) <= 360 then
          '12'
         else
          '12+'
       end shop_age_month,
       trunc((select min(t.receipt_date)
          from INVENTORY_PART_IN_STOCK_NOPAL t
         where t.part_no = i.part_no
           and t.serial_no = i.serial_no)) mgt_receipt_date,
       nvl((select s.sales_price
             from ifsapp.SALES_PRICE_LIST_PART s
            where s.price_list_no = '1'
              and s.valid_from_date =
                  (select max(p.valid_from_date)
                     from ifsapp.SALES_PRICE_LIST_PART p
                    where p.price_list_no = '1'
                      and p.valid_from_date <= sysdate
                      and p.catalog_no = s.catalog_no)
              and s.catalog_no = i.part_no),
           0) NSP,
       (select s.cash_tax_code
          from ifsapp.SALES_PRICE_LIST_PART s
         where s.price_list_no = '1'
           and s.valid_from_date =
               (select max(p.valid_from_date)
                  from ifsapp.SALES_PRICE_LIST_PART p
                 where p.price_list_no = '1'
                   and p.valid_from_date <= sysdate
                   and p.catalog_no = s.catalog_no)
           and s.catalog_no = i.part_no) VAT_CODE,
       nvl((((ifsapp.STATUTORY_FEE_API.Get_Fee_Rate('SBL',
                                                    (select s.cash_tax_code
                                                       from ifsapp.SALES_PRICE_LIST_PART s
                                                      where s.price_list_no = '1'
                                                        and s.valid_from_date =
                                                            (select max(p.valid_from_date)
                                                               from ifsapp.SALES_PRICE_LIST_PART p
                                                              where p.price_list_no = '1'
                                                                and p.valid_from_date <=
                                                                    sysdate
                                                                and p.catalog_no =
                                                                    s.catalog_no)
                                                        and s.catalog_no =
                                                            i.part_no))) / 100) *
           (select s.sales_price
               from ifsapp.SALES_PRICE_LIST_PART s
              where s.price_list_no = '1'
                and s.valid_from_date =
                    (select max(p.valid_from_date)
                       from ifsapp.SALES_PRICE_LIST_PART p
                      where p.price_list_no = '1'
                        and p.valid_from_date <= sysdate
                        and p.catalog_no = s.catalog_no)
                and s.catalog_no = i.part_no)),
           0) VAT
  from ifsapp.INVENTORY_PART_IN_STOCK_NOPAL i
 WHERE i.qty_onhand > 0
   and IFSAPP.PART_CATALOG_API.Get_Serial_Tracking_Code(i.part_no) =
       'Serial Tracking'
   and ifsapp.inventory_part_api.Get_Part_Product_Family(i.contract,
                                                         i.part_no) !=
       'RBOOK'
   /*and i.part_no = 'SRAC-SAS12L78WVMGA' --'SRREF-SINGER-BD-142-GL'
   and i.serial_no = 664*/
   order by i.contract, i.part_no, i.serial_no
