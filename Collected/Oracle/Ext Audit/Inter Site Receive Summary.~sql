--***** Inter Site Receive Summary
select R.contract,
       R.contract || '-' || R.part_no site_part_no,
       R.part_no,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(R.contract,
                                                                                                         R.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(R.contract,
                                                                                                             R.part_no)) product_family,
       sum(R.qty_arrived) qty_arrived,
       sum(round(R.qty_arrived *
                 (select c.cost
                    from ifsapp.INVENT_ONLINE_COST_TAB c
                   where c.year = extract(year from trunc(R.arrival_date))
                     and c.period =
                         extract(month from trunc(R.arrival_date))
                     and c.contract = R.contract
                     and c.part_no = R.part_no),
                 2)) total_cost
  from IFSAPP.PURCHASE_RECEIPT_NEW R
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     R.vendor_no,
                                                     'Supplier') != '0'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(R.contract,
                                                         R.part_no) !=
       'RBOOK'
      /*and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', R.part_no) !=
          'RAW'
      and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', R.part_no) not like
          'S-%'*/
   and trunc(R.arrival_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and R.state != 'Cancelled'
/*and R.vendor_no not in
('XLBD-SACF', 'XLBD-SRAV', 'XLBD-SRFR', 'XLBD-IAL')*/
 group by R.contract, R.part_no
 order by 1, 2, 5, 4, 3
