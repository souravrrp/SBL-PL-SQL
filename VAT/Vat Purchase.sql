/* Formatted on 9/7/2022 3:34:05 PM (QP5 v5.381) */
SELECT srd.po_no,
       srd.line_no,
       srd.receipt_no,
       srm.ri_date                                                    receipt_date,
       srd.item_code,
       srd.ri_accept_qty                                              qty,
       srd.total_amount                                               amount,
       srd.vat_amt                                                    vat_amt,
       --ROUND ((srd.vat_amt * 100) / srd.total_amount)                 vat_percent,
       srm.challan_no,
       srm.SUP_NO,
       ssm.SUP_DESC                                                   supplier_name,
       ssm.SUP_ADD1 || ',' || ssm.SUP_ADD2 || ',' || ssm.SUP_PHONE    sup_address
  FROM vatdev.sbpa_ri_dtl        srd,
       sbpa_item_mst             sim,
       vatdev.sbpa_ri_mst        srm,
       VATDEV.SBPA_SUPPLIER_MST  ssm
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type IN ('001',
                             '002',
                             '003',
                             '007')
       AND srm.ri_mst_id = srd.ri_mst_id
       AND TO_CHAR (srm.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND po_type_code = 'PT-0002'
       AND srm.sup_no = ssm.sup_no;



SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.ri_date           receipt_date,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount       amount,
       srd.vat_percent,
       srd.challan_no
  FROM SBL_VAT_PO_RI_DTL_SPARE srd, SBL_VAT_ITEM_MASTER sim
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '007'
       AND TO_CHAR (srd.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND srd.po_type_code = 'PT-0001'
UNION ALL
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.ri_date           receipt_date,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount       amount,
       srd.vat_percent,
       srd.challan_no
  FROM SBL_VAT_PO_RI_DTL_RM srd, SBL_VAT_ITEM_MASTER sim
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '001'
       AND TO_CHAR (srd.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND srd.po_type_code = 'PT-0001'
UNION ALL
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.ri_date           receipt_date,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount       amount,
       srd.vat_percent,
       srd.challan_no
  FROM SBL_VAT_PO_RI_DTL_FG srd, SBL_VAT_ITEM_MASTER sim
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '002'
       AND TO_CHAR (srd.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND srd.po_type_code = 'PT-0001'
UNION ALL
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.ri_date           receipt_date,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount       amount,
       srd.vat_percent,
       srd.challan_no
  FROM SBL_VAT_PO_RI_DTL_SERV srd, sbpa_item_mst sim
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '003'
       AND TO_CHAR (srd.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND srd.po_type_code = 'PT-0001';