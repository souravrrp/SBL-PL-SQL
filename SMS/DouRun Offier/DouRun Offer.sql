/* Formatted on 4/18/2023 3:10:10 PM (QP5 v5.381) */
SELECT cot.order_no,
       cot.date_entered
           sales_date,
       colt.customer_no,
       ifsapp.customer_info_api.get_name (colt.customer_no)
           customer_name,
       ifsapp.customer_info_comm_method_api.get_any_phone_no (
           colt.customer_no)
           phone_number,
       colt.part_no,
       colt.buy_qty_due
           qty,
       colt.base_sale_unit_price
           unit_price,
       (colt.buy_qty_due * colt.base_sale_unit_price)
           nsp,
       ifsapp.customer_order_api.Get_Ord_Gross_Amount (cot.order_no)
           Gross_Amount,
       ifsapp.customer_order_api.Get_Total_Base_Charge__ (cot.order_no)
           Charge_Amount,
       ifsapp.customer_order_line_api.get_total_tax_amount (
           colt.order_no,
           colt.line_no,
           colt.rel_no,
           colt.line_item_no)
           vat_amount,
       ifsapp.customer_order_line_api.get_sale_price_total (
           colt.order_no,
           colt.line_no,
           colt.rel_no,
           colt.line_item_no)
           discounted_nsp,
       (  ifsapp.customer_order_line_api.get_sale_price_total (
              colt.order_no,
              colt.line_no,
              colt.rel_no,
              colt.line_item_no)
        + ifsapp.customer_order_line_api.get_total_tax_amount (
              colt.order_no,
              colt.line_no,
              colt.rel_no,
              colt.line_item_no))
           discounted_rsp,
       ifsapp.customer_order_api.Get_Total_Base_Price (cot.order_no)
           Total_Base_Price,
       cot.rowstate
           status,
       ifsapp.get_sbl_order_vat_receipt (colt.order_no,
                                         colt.line_no,
                                         colt.rel_no,
                                         colt.line_item_no)
           vat_receipt_no
  --,cot.*
  --,colt.*
  FROM ifsapp.customer_order_tab cot, ifsapp.customer_order_line_tab colt
 WHERE     1 = 1
       AND cot.order_no = colt.order_no
       --AND colt.catalog_no IN ('SRTV-SLE24D2010TC')
       AND colt.catalog_no IN ('SRTV-SLE24D2010TC','SRTV-SLE32E3AHDTV','SRTV-SLE32E3AWSTV','SRTV-SLE32E3AGOTV','SRTV-SLE32D6100GOTV','SRTV-SLE40E3AFHTV','SRTV-SLE43A5000GOTV','SRTV-SLE43U5000GOTV','SRTV-SLE50U5000GOTV','SRTV-SLE55U5000GOTV','SRTV-SLE50G22GOTV')
       --and cot.customer_no='W0002991-2'
       --AND cot.order_no like ('%SIS-R4991%')
       --AND EXISTS (SELECT 1 FROM ifsapp.customer_info_comm_method cicm WHERE ( :p_customer_phone IS NULL OR (cicm.value = :p_customer_phone)))
       AND ( :p_order_no IS NULL OR (cot.order_no = :p_order_no))
       AND (   :p_part_no IS NULL
            OR (UPPER (colt.catalog_no) LIKE UPPER ('%' || :p_part_no || '%')))
       AND ( :p_customer_no IS NULL OR (cot.customer_no = :p_customer_no))
       AND TRUNC (cot.date_entered) BETWEEN NVL ( :p_date_from,
                                                 TRUNC (cot.date_entered))
                                        AND NVL ( :p_date_to,
                                                 TRUNC (cot.date_entered));

--------------------------------*********************---------------------------
