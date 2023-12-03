--Finished Goods received in Factory Site
select p.order_no,
       p.line_no,
       p.release_no,
       p.receipt_no,
       p.grn_no,
       p.contract "SITE",
       p.part_no,
       p.description,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         p.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             p.part_no)) product_family_description,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(ifsapp.inventory_part_api.Get_Second_Commodity('SCOM',
                                                                                                 p.part_no)) comm_group_2,
       p.vendor_no,
       p.qty_arrived,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(p.order_no,
                                                         p.line_no,
                                                         p.release_no) Buy_Unit_Price,
       (IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(p.order_no,
                                                          p.line_no,
                                                          p.release_no) *
       p.qty_arrived) Total_Price,
       to_char(p.arrival_date, 'YYYY/MM/DD') arrival_date,
       p.state
  from IFSAPP.PURCHASE_RECEIPT_NEW p
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     p.vendor_no,
                                                     'Supplier') = '0'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', p.part_no) !=
       'RBOOK'
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', p.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', p.part_no) not like
       'S-%'
   and p.part_no like '&part_no'
   and trunc(p.arrival_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and p.state not in 'Cancelled'
   and p.contract in ('SAVF', 'SACF'/*, 'SFRF'*/)
 order by p.contract, p.arrival_date, p.part_no
