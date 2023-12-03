--***** Product with Vendor Info
select a.part_no,
       ifsapp.inventory_part_api.Get_Description('SCOM', a.part_no) "DESCRIPTION",
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             a.part_no)) product_family,
       b.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(b.vendor_no) vendor_name
  from (select t.stat_year, t.stat_period_no, t.part_no
          from IFSAPP.REP246_TAB t
         where t.stat_year = '&year_i'
           and t.stat_period_no = '&period'
           and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(t.contract,
                                                                 t.part_no) not in
               ('RBOOK', 'GV')
           and ifsapp.inventory_part_api.Get_Part_Product_Code(t.contract,
                                                               t.part_no) !=
               'RAW'
           and ifsapp.inventory_part_api.Get_Second_Commodity(t.contract,
                                                              t.part_no) not like
               'S-%'
         group by t.stat_year, t.stat_period_no, t.part_no
        having sum(t.cf_balance) > 0) a
  left join (select s.part_no, s.vendor_no
               from ifsapp.PURCHASE_PART_SUPPLIER s
              where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                                  s.vendor_no,
                                                                  'Supplier') = '0'
                and s.vendor_no like 'X%'
              group by s.part_no, s.vendor_no) b
    on a.part_no = b.part_no
 order by a.part_no
