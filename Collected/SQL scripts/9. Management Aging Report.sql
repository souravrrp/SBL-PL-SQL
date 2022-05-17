select t.shop_code,
       t.area_code,
       t.district_code,
       t.delivery_site,
       t.brand,
       t.product_family,
       t.product_family_description,
       t.comm_group_2,
       t.part_no,
       t.serial_no,
       t.Oem_No,
       t.qty_onhand,
       t.receipt_date,
       t.age,
       t.age_month,
       (select trunc(date_created)
          from part_serial_catalog p
         where t.part_no = p.part_no
           and t.serial_no = p.serial_no) AS MGT_RECEIPT_DATE,
       trunc(sysdate) - (select trunc(date_created)
                           from ifsapp.part_serial_catalog p
                          where t.part_no = p.part_no
                            and t.serial_no = p.serial_no) MGT_AGE,
       case
         when trunc(sysdate) -
              (select trunc(date_created)
                 from ifsapp.part_serial_catalog p
                where t.part_no = p.part_no
                  and t.serial_no = p.serial_no) <= 90 then
          '03'
         when trunc(sysdate) -
              (select trunc(date_created)
                 from ifsapp.part_serial_catalog p
                where t.part_no = p.part_no
                  and t.serial_no = p.serial_no) <= 180 then
          '06'
         when trunc(sysdate) -
              (select trunc(date_created)
                 from ifsapp.part_serial_catalog p
                where t.part_no = p.part_no
                  and t.serial_no = p.serial_no) <= 270 then
          '09'
         when trunc(sysdate) -
              (select trunc(date_created)
                 from ifsapp.part_serial_catalog p
                where t.part_no = p.part_no
                  and t.serial_no = p.serial_no) <= 360 then
          '12'
         else
          '12+'
       end age_month,
       t.NSP,
       t.VAT_CODE,
       t.VAT,
       
       (SELECT i.COST
          from ifsapp.INVENT_ONLINE_COST_TAB i
         where i.contract = t.shop_code
           and i.part_no = t.part_no
           and i.year =
               extract(year
                       from(trunc(TO_DATE('&DATE', 'YYYY/MM/DD'), 'MM') - 1))
           and i.period =
               extract(month
                       from(trunc(TO_DATE('&DATE', 'YYYY/MM/DD'), 'MM') - 1))) AS UNIT_COST

  FROM ifsapp.SBL_VW_PRODUCT_AGING t
 WHERE t.shop_code like '&SHOP_CODE'
