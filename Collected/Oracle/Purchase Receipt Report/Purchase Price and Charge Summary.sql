--Product Receive Quantity
select R.order_no,
       R.shipment_id,
       trunc(R.arrival_date) arrival_date,
       R.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(R.vendor_no) vendor_name,
       sum(R.qty_arrived) quantity,
       sum(IFSAPP.PURCHASE_ORDER_LINE_API.Get_Fbuy_Unit_Price(R.order_no,
                                                              R.line_no,
                                                              R.release_no) *
           R.qty_arrived) Total_FOV,
       sum(IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(R.order_no,
                                                             R.line_no,
                                                             R.release_no) *
           R.qty_arrived) Total_Price,
       nvl((select sum(c.charge_price_curr)
             from ifsapp.PURINV_CHARGE_ENTRY c
            where c.charge_type = 'FREIGHT'
              and c.shipment_id = R.shipment_id),
           0) freight_charge
  from IFSAPP.PURCHASE_RECEIPT_NEW R
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     R.vendor_no,
                                                     'Supplier') = '0'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(R.contract,
                                                         R.part_no) not in
       ('RBOOK', 'GIFT VOUCHER')
      /*and ifsapp.inventory_part_api.Get_Part_Product_Code(R.contract, R.part_no) !=
          'RAW'
      and ifsapp.inventory_part_api.Get_Second_Commodity(R.contract, R.part_no) not like
          'S-%'*/
   and trunc(R.arrival_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and R.state != 'Cancelled'
   and R.vendor_no in /*('XFCH-HMCO', 'XFHK-TMIL')*/ ('XFCH-GALA', 'XFSP-MIDEA', 'XFHK-THAC')
   and R.part_no like '%AC-%'
 group by R.order_no, R.shipment_id, trunc(R.arrival_date), R.vendor_no
 order by 1, 2, 3
