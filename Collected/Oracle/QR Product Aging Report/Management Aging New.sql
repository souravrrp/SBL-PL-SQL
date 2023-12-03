--***** Management Aging
select v.shop_code,
       v.area_code,
       v.district_code,
       v.brand,
       v.product_family,
       v.product_family_description,
       v.comm_group_2,
       v.part_no,
       v.serial_no,
       v.Oem_No,
       v.qty_onhand,
       v.receipt_date,
       v.age,
       v.age_month,
       (select trunc(c.date_created)
          from IFSAPP.PART_SERIAL_CATALOG c
         where c.part_no = v.part_no
           and c.serial_no = v.serial_no) mgt_receipt_date,
       trunc(sysdate) - (select trunc(c.date_created)
                           from IFSAPP.PART_SERIAL_CATALOG c
                          where c.part_no = v.part_no
                            and c.serial_no = v.serial_no) mgt_age,
       case
         when trunc(sysdate) -
              (select trunc(c.date_created)
                 from IFSAPP.PART_SERIAL_CATALOG c
                where c.part_no = v.part_no
                  and c.serial_no = v.serial_no) <= 90 then
          '03'
         when trunc(sysdate) -
              (select trunc(c.date_created)
                 from IFSAPP.PART_SERIAL_CATALOG c
                where c.part_no = v.part_no
                  and c.serial_no = v.serial_no) <= 180 then
          '06'
         when trunc(sysdate) -
              (select trunc(c.date_created)
                 from IFSAPP.PART_SERIAL_CATALOG c
                where c.part_no = v.part_no
                  and c.serial_no = v.serial_no) <= 270 then
          '09'
         when trunc(sysdate) -
              (select trunc(c.date_created)
                 from IFSAPP.PART_SERIAL_CATALOG c
                where c.part_no = v.part_no
                  and c.serial_no = v.serial_no) <= 360 then
          '12'
         else
          '12+'
       end mgt_age_month,
       /*v.mgt_receipt_date,
       v.mgt_age,
       v.mgt_age_month,*/
       v.NSP,
       v.VAT_CODE,
       v.VAT,
       (select c.cost
          from ifsapp.invent_online_cost_tab c
         where c.year = extract(year from trunc(sysdate, 'mm') - 1)
           and c.period = extract(month from trunc(sysdate, 'mm') - 1)
           and c.contract = v.shop_code
           and c.part_no = v.part_no) UNIT_COST
  from sbl_vw_product_aging v
 WHERE v.shop_code like '&shop_code'
   /*AND v.area_code like '&area_code'*/
   /*and v.product_family \*like '&product_family'*\
       in ('COMPUTER-LAPTOP', 'COMPUTER-DESKTOP')*/
   /*and v.part_no like '&part_no'
   and v.age >= '&age'*/
 order by v.district_code, v.shop_code, v.product_family, v.part_no /*,
          v.receipt_date*/
