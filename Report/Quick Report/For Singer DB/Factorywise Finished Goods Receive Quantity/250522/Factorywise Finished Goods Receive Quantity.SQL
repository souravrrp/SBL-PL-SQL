select p.order_no, p.line_no, p.release_no, p.receipt_no, p.grn_no, p.contract "SITE",
       p.part_no, p.description,      IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', p.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM', p.part_no)) product_family_description,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', p.part_no)) comm_group_2,
       p.vendor_no, p.qty_arrived,
       (select l.buy_unit_price
          from IFSAPP.PURCHASE_ORDER_LINE_TAB l
         where l.order_no = p.order_no
           and l.line_no = p.line_no
           and l.release_no = p.release_no) buy_unit_price,
       ((select l.buy_unit_price
           from IFSAPP.PURCHASE_ORDER_LINE_TAB l
          where l.order_no = p.order_no
            and l.line_no = p.line_no
            and l.release_no = p.release_no) * p.qty_arrived) total_price,
       to_char(p.arrival_date, 'YYYY/MM/DD') arrival_date,
       p.state
  from PURCHASE_RECEIPT_NEW p
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     p.vendor_no,
                                                     'Supplier') = '0'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', p.part_no) !=
       'RBOOK'
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', p.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', p.part_no) not like
       'S--%'
   and p.part_no like '&part_no'
   and p.arrival_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and p.state not in 'Cancelled'
   and p.contract in ('SAVF', 'SACF', 'SFRF')
 order by p.arrival_date, p.part_no