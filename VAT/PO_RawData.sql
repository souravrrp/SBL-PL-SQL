/* Formatted on 8/25/2022 12:57:14 PM (QP5 v5.381) */
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount       amount,
       --srd.vat_amt                                        vat_amt,
       --ROUND ((srd.vat_amt * 100) / srd.total_amount)     vat_percent,
       round(srd.vat_percent)
  --srm.challan_no
  FROM SBL_VAT_PO_RI_DTL_SPARE  srd,
       SBL_VAT_ITEM_MASTER      sim,
       SBL_VAT_PO_RI_MASTER     srm
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '007'
       AND srm.po_no = srd.order_no
       AND srm.receipt_no = srd.receipt_no
       AND TO_CHAR (srm.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND srm.po_type_code = 'PT-0001'
UNION ALL
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount       amount,
       round(srd.vat_percent)
  --srm.challan_no
  FROM SBL_VAT_PO_RI_DTL_SERV srd, sbpa_item_mst sim
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '003'
       AND TO_CHAR (srd.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND srd.po_type_code = 'PT-0001'
UNION ALL
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount       amount,
       round(srd.vat_percent)
  --srm.challan_no
  FROM SBL_VAT_PO_RI_DTL_FG srd, sbpa_item_mst sim
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '002'
       AND TO_CHAR (srd.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND srd.po_type_code = 'PT-0001'
UNION ALL
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount       amount,
       round(srd.vat_percent)
  --srm.challan_no
  FROM SBL_VAT_PO_RI_DTL_RM srd, sbpa_item_mst sim
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '001'
       AND TO_CHAR (srd.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND srd.po_type_code = 'PT-0001';