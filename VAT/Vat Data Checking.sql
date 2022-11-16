/* Formatted on 7/21/2022 1:07:33 PM (QP5 v5.381) */
-----------------------------Order----------------------------------------------

SELECT *
  FROM ifsapp.customer_order co
 WHERE order_no IN ('SAP-R5049');

SELECT *
  FROM SBL_VAT_CUST_ORDER_RTL
 WHERE ORDER_NO IN ('SAP-R5049');

  SELECT t.c1    ORDER_NO,
         CASE
             WHEN t.net_curr_amount = 0
             THEN
                 ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE (t.invoice_id,
                                                       t.item_id,
                                                       t.c1)
             ELSE
                 ifsapp.get_sbl_account_status (t.c1,
                                                t.c2,
                                                t.c3,
                                                t.c5,
                                                t.net_curr_amount,
                                                i.invoice_date)
         END     status
    FROM ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
   WHERE     t.invoice_id = i.invoice_id
         AND t.c1 IN ('SAP-R5049')
         --AND i.invoice_date BETWEEN :P_From_Date AND :P_To_Date
         AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
         AND t.rowstate = 'Posted'
         AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) IN ('INV', 'PKG')
         AND t.c10 NOT IN ('BSCP',
                           'BLSP',
                           'CLSP',
                           'CSCP',
                           'CXSP',
                           'DSCP',
                           'JSCP',
                           'KSCP',
                           'MSCP',
                           'NSCP',
                           'RPSP',
                           'RSCP',
                           'SSCP',
                           'MS1C',
                           'MS2C',
                           'BTSC')
ORDER BY t.c10, t.c1, i.invoice_date;

  SELECT scom.order_no, SUM (scod.qnty) qty, SUM (scod.rate) amount
    FROM vatdev.sbpa_cust_order_mst scom,
         vatdev.sbpa_cust_order_dtl scod,
         sbpa_item_mst             sim
   WHERE     1 = 1
         AND scom.order_id = scod.order_mst_id
         AND delivery_date BETWEEN '01-mar-2022' AND '31-mar-2022'
         AND scod.ITEM_CODE = sim.ITEM_CODE
         AND sim.item_type = '002'
GROUP BY scom.order_no;

SELECT *
  FROM SBL_VAT_CUST_ORDER_RTL
 WHERE 1 = 1 AND ORDER_NO = 'SAP-R5049';

-----------------------------Delivery----------------------------------------------

  SELECT DISTINCT NULL            ORDER_ID,
                  ORDER_NO,
                  ORDER_DATE,
                  CUSTOMER_NO     CUST_NO,
                  DELIVERY_DATE
    FROM SBL_VAT_CUST_ORDER_DELIV_DTL
   WHERE 1 = 1     --AND DELIVERY_DATE BETWEEN '01-mar-2022' AND '31-mar-2022'
               AND ORDER_NO = 'SAP-R5049'
ORDER BY ORDER_DATE;

SELECT *
  FROM ifsapp.customer_order_line_tab l
 WHERE 1 = 1 AND ORDER_NO = 'SAP-R5049';

SELECT *
  FROM vatdev.sbpa_cust_prod_delivery_dtl scpdd
 WHERE 1 = 1 AND ORDER_NO = 'CMP-H4326';


SELECT *
  FROM vatdev.sbpa_cust_prod_delivery_mst scpdm
 WHERE 1 = 1 AND ORDER_NO = 'SSC-R33698';

  SELECT scpdm.order_no,
         SUM (delivery_qnty)     qty,
         SUM (delivery_amt)      amount,
         SUM (vat_amount)        vat_amount
    FROM vatdev.sbpa_cust_prod_delivery_mst scpdm,
         vatdev.sbpa_cust_prod_delivery_dtl scpdd,
         sbpa_item_mst                     sim
   WHERE     1 = 1
         AND scpdm.delivery_id = scpdd.delivery_mst_id
         AND delivery_date BETWEEN '01-mar-2022' AND '31-mar-2022'
         AND scpdd.item_code = sim.item_code
         AND sim.item_type = '002'
GROUP BY scpdm.order_no;


-----------------------------Return Order---------------------------------------

  SELECT scirm.ORDER_NO,
         SUM (scird.QNTY)     qty,
         SUM (rate)           amount,
         SUM (VAT_AMOUNT)     vat
    FROM vatdev.sbpa_cust_item_return_mst scirm,
         vatdev.sbpa_cust_item_return_dtl scird
   WHERE     1 = 1
         AND TO_CHAR (scirm.RETURN_DATE, 'MON-YYYY') = 'MAR-2022'
         AND scirm.CUST_RETURN_ID = scird.CUST_RETURN_MST_ID
GROUP BY scirm.ORDER_NO;

-----------------------------Return Order---------------------------------------

SELECT *
  FROM vatdev.sbpa_po_dtl spd
 WHERE 1 = 1 AND spd.PO_NO = 'A-30815376';

SELECT *
  FROM vatdev.sbpa_po_mst spm
 WHERE 1 = 1
--AND spm.PO_NO = 'A-30815376'
;

SELECT srm.*
  FROM vatdev.sbpa_ri_mst srm, vatdev.sbpa_ri_dtl srd
 WHERE 1 = 1 AND srd.PO_NO = 'A-30815376' AND srm.RI_MST_ID = srd.RI_MST_ID;

  SELECT srd.PO_NO,
         srd.LINE_NO,
         srd.RECEIPT_NO,
         srd.ITEM_CODE,
         srd.RI_ACCEPT_QTY                          qty,
         TOTAL_AMOUNT                               amount,
         VAT_AMT                                    VAT_AMT,
         ROUND ((VAT_AMT * 100) / TOTAL_AMOUNT)     vat_percent,
         srchallan_no
    --
    --SUM (srd.RI_ACCEPT_QTY)                                qty,
    --SUM (TOTAL_AMOUNT)                                     amount,
    --SUM (VAT_AMT)                                          VAT_AMT,
    --ROUND ((SUM (VAT_AMT) * 100) / SUM (TOTAL_AMOUNT))     vat_percent
    FROM vatdev.sbpa_ri_dtl srd, sbpa_item_mst sim
   WHERE     1 = 1
         AND srd.ITEM_CODE = sim.ITEM_CODE
         AND sim.item_type = '003'
         AND EXISTS
                 (SELECT 1
                    FROM vatdev.sbpa_ri_mst srm
                   WHERE     1 = 1
                         --AND srm.PO_NO = 'L-29609'
                         AND srm.RI_MST_ID = srd.RI_MST_ID
                         AND TO_CHAR (srm.RI_DATE, 'MON-YYYY') = 'MAR-2022'
                         AND PO_TYPE_CODE = 'PT-0001')
--GROUP BY srd.PO_NO,
--         srd.LINE_NO,
--         srd.RECEIPT_NO,
--         srd.ITEM_CODE
;

SELECT srd.po_no,
       srd.line_no,
       srd.receipt_no,
       srd.item_code,
       srd.ri_accept_qty                          qty,
       srd.total_amount                               amount,
       srd.vat_amt                                    vat_amt,
       ROUND ((srd.vat_amt * 100) / srd.total_amount)     vat_percent,
       srm.challan_no
  FROM vatdev.sbpa_ri_dtl srd, sbpa_item_mst sim, vatdev.sbpa_ri_mst srm
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '007'
       AND srm.ri_mst_id = srd.ri_mst_id
       AND TO_CHAR (srm.ri_date, 'MON-YYYY') = 'MAR-2022'
       AND po_type_code = 'PT-0001'
       --and srd.vat_amt=0
       and srm.challan_no is null;
       
       /* Formatted on 7/21/2022 2:37:06 PM (QP5 v5.381) */
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount                                   amount,
       --srd.vat_amt                                        vat_amt,
       --ROUND ((srd.vat_amt * 100) / srd.total_amount)     vat_percent,
       srd.vat_percent,
       srm.challan_no
  FROM SBL_VAT_PO_RI_DTL_SPARE  srd,
       SBL_VAT_ITEM_MASTER      sim,
       SBL_VAT_PO_RI_MASTER     srm
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '007'
       AND srm.po_no = srd.order_no
       AND srm.receipt_no = srd.receipt_no
       AND TO_CHAR (srm.ri_date, 'MON-YYYY') = 'JUN-2022'
       AND srm.po_type_code = 'PT-0001'
--and srd.vat_amt=0
--and srm.challan_no is null
;

/* Formatted on 7/21/2022 2:37:06 PM (QP5 v5.381) */
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount                                   amount,
       --srd.vat_amt                                        vat_amt,
       --ROUND ((srd.vat_amt * 100) / srd.total_amount)     vat_percent,
       srd.vat_percent,
       srm.challan_no
  FROM SBL_VAT_PO_RI_DTL_SERV  srd,
       SBL_VAT_ITEM_MASTER      sim,
       SBL_VAT_PO_RI_MASTER     srm
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '003'
       AND srm.po_no = srd.order_no
       AND srm.receipt_no = srd.receipt_no
       AND TO_CHAR (srd.ri_date, 'MON-YYYY') = 'JUN-2022'
       AND srm.po_type_code = 'PT-0001'
--and srd.vat_amt=0
--and srm.challan_no is null
;

/* Formatted on 7/21/2022 2:37:06 PM (QP5 v5.381) */
SELECT srd.order_no,
       srd.line_no,
       srd.receipt_no,
       srd.item_code,
       srd.ri_accept_qty     qty,
       srd.item_amount                                   amount,
       --srd.vat_amt                                        vat_amt,
       --ROUND ((srd.vat_amt * 100) / srd.total_amount)     vat_percent,
       srd.vat_percent
       --srm.challan_no
  FROM SBL_VAT_PO_RI_DTL_SERV  srd,
       sbpa_item_mst      sim
 WHERE     1 = 1
       AND srd.item_code = sim.item_code
       AND sim.item_type = '003'
       AND TO_CHAR (srd.ri_date, 'MON-YYYY') = 'JUN-2022'
       AND srd.po_type_code = 'PT-0001'
--and srd.vat_amt=0
--and srm.challan_no is null
;