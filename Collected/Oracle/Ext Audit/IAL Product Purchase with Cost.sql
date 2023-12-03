--***** IAL Product Purchase with Cost
select R.order_no,
       R.line_no,
       R.release_no,
       R.receipt_no,
       R.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(R.vendor_no) vendor_name,
       R.contract,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         R.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             R.part_no)) product_family,
       R.part_no,
       R.description,
       R.qty_arrived,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(R.order_no,
                                                         R.line_no,
                                                         R.release_no) Buy_Unit_Price,
       (IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(R.order_no,
                                                          R.line_no,
                                                          R.release_no) *
       R.qty_arrived) Total_Price,
       round((select c.cost
               from ifsapp.INVENT_ONLINE_COST_TAB c
              where c.year = extract(year from R.arrival_date)
                and c.period = extract(month from R.arrival_date)
                and c.contract = R.contract
                and c.part_no = R.part_no),
             2) unit_cost,
       /*IFSAPP.PURCHASE_ORDER_LINE_API.Get_Fbuy_Unit_Price(R.order_no,
                                                          R.line_no,
                                                          R.release_no) Fbuy_Unit_Price,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Currency_Rate(R.order_no,
                                                        R.line_no,
                                                        R.release_no) Currency_Rate,*/
       to_char(R.arrival_date, 'YYYY/MM/DD') arrival_date,
       IFSAPP.PURCHASE_ORDER_API.Get_Lc_No(R.order_no) LC_NO,
       R.grn_no,
       R.shipment_id,
       R.state
  from IFSAPP.PURCHASE_RECEIPT_NEW R
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     R.vendor_no,
                                                     'Supplier') = '0'
   /*and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', R.part_no) !=
       'RBOOK'
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', R.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', R.part_no) not like
       'S-%'*/
   and trunc(R.arrival_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and R.state != 'Cancelled'
   /*and R.vendor_no = 'XLBD-IAL'*/
   and R.part_no in ('SRREF-SINGER-BCD-333R-RG',
                     'SRREF-SINGER-BCD-333R-BG',
                     'SRREF-SINGER-BCD-273R-RG',
                     'SRREF-SINGER-BCD-273R-BG',
                     'SRREF-SINGER-BCD-243R-RG',
                     'SRREF-SINGER-BCD-243R-BG',
                     'SRREF-SINGER-BCD-218R-RG',
                     'SRREF-SINGER-BCD-218R-BG',
                     'SRREF-SINGER-BCD-218R',
                     'SRREF-SINGER-BCD-218I-GMF',
                     'SRREF-SINGER-BCD-218I-DRS',
                     'SRREF-SINGER-BCD-218I-BVS',
                     'SRREF-SINGER-BCD-218I',
                     'SRREF-SINGER-BCD-218F-DRS',
                     'SRREF-SINGER-BCD-218F',
                     'SRREF-SINGER-BCD-208R-RG',
                     'SRREF-SINGER-BCD-208R-BG',
                     'SRREF-SINGER-BCD-208R',
                     'SRREF-SINGER-BCD-208I-RMF',
                     'SRREF-SINGER-BCD-208I-GMF',
                     'SRREF-SINGER-BCD-208I-DRS',
                     'SRREF-SINGER-BCD-208I-BVS',
                     'SRREF-SINGER-BCD-208I',
                     'SRREF-SINGER-BCD-198R-RG',
                     'SRREF-SINGER-BCD-198R-BG',
                     'SRREF-SINGER-PRO-212R-BG',
                     'SRREF-SINGER-PRO-212R-RG',
                     'SRREF-SINGER-BCD-198R',
                     'SRREF-SINGER-BCD-198I-GMF',
                     'SRREF-SINGER-BCD-198I-DRS',
                     'SRREF-SINGER-BCD-198I-BVS',
                     'SRREF-SINGER-BCD-198I',
                     'SRREF-SINGER-BCD-198F-DRS',
                     'SRREF-SINGER-BCD-198F')
 order by 1, 2
