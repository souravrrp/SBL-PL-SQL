-- ***** Inventory Position with PO
select t.*,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(t.contract,
                                                                                                             t.part_no)) product_family,
       decode(t.serial_no,
              '*',
              (select max(h.order_no)
                 from IFSAPP.INVENTORY_TRANSACTION_HIST h
                where h.contract = t.contract
                  and h.part_no = t.part_no
                  and h.serial_no = t.serial_no
                  and trunc(h.dated) = trunc(t.receipt_date)
                  and h.direction = '+'
               ),
              (select h.order_no
                 from IFSAPP.INVENTORY_TRANSACTION_HIST h
                where h.contract = t.contract
                  and h.part_no = t.part_no
                  and h.serial_no = t.serial_no
                  and trunc(h.dated) = trunc(t.receipt_date)
                  and h.direction = '+'
               )) purchase_order,
       decode(t.serial_no,
              '*',
              (select max(h.dated)
                 from IFSAPP.INVENTORY_TRANSACTION_HIST h
                where h.contract = t.contract
                  and h.part_no = t.part_no
                  and h.serial_no = t.serial_no
                  and trunc(h.dated) = trunc(t.receipt_date)
                  and h.direction = '+'
               ),
              (select h.dated
                 from IFSAPP.INVENTORY_TRANSACTION_HIST h
                where h.contract = t.contract
                  and h.part_no = t.part_no
                  and h.serial_no = t.serial_no
                  and trunc(h.dated) = trunc(t.receipt_date)
                  and h.direction = '+'
               )) dated,
       decode(t.serial_no,
              '*',
              (select max(h.transaction_code)
                 from IFSAPP.INVENTORY_TRANSACTION_HIST h
                where h.contract = t.contract
                  and h.part_no = t.part_no
                  and h.serial_no = t.serial_no
                  and trunc(h.dated) = trunc(t.receipt_date)
                  and h.direction = '+'
               ),
              (select h.transaction_code
                 from IFSAPP.INVENTORY_TRANSACTION_HIST h
                where h.contract = t.contract
                  and h.part_no = t.part_no
                  and h.serial_no = t.serial_no
                  and trunc(h.dated) = trunc(t.receipt_date)
                  and h.direction = '+'
               )) transaction_code
  from IFSAPP.INVENTORY_PART_IN_STOCK t
 where t.contract in ('CTGW', 'CTWW', 'CTCW')
   and t.qty_onhand > 0
   /*and t.serial_no != '*'*/
   /*and t.part_no = 'PTWTP-PUREIT-MICRO-F-MASH'*/
