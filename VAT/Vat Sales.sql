/* Formatted on 9/5/2022 10:26:34 AM (QP5 v5.381) */
  SELECT scpdm.order_no,
         scpdd.item_code,
         SUM (delivery_qnty)     qty,
         SUM (delivery_amt)      amount,
         SUM (vat_amount)        vat_amount
    --ROUND ((SUM (vat_amount) * 100) / SUM (delivery_amt))     vat_percent
    FROM vatdev.sbpa_cust_prod_delivery_mst scpdm,
         vatdev.sbpa_cust_prod_delivery_dtl scpdd,
         sbpa_item_mst                     sim
   WHERE     1 = 1
         AND scpdm.delivery_id = scpdd.delivery_mst_id
         AND delivery_date BETWEEN '01-mar-2022' AND '31-mar-2022'
         AND scpdd.item_code = sim.item_code
         AND sim.item_type = '002'
GROUP BY scpdm.order_no, scpdd.item_code;

  SELECT scirm.ORDER_NO,
         scird.item_code,
         SUM (scird.QNTY)     qty,
         SUM (rate)           amount,
         SUM (VAT_AMOUNT)     vat
    FROM vatdev.sbpa_cust_item_return_mst scirm,
         vatdev.sbpa_cust_item_return_dtl scird,
         sbpa_item_mst                   sim
   WHERE     1 = 1
         AND TO_CHAR (scirm.RETURN_DATE, 'MON-YYYY') = 'MAR-2022'
         AND scirm.CUST_RETURN_ID = scird.CUST_RETURN_MST_ID
         AND scird.item_code = sim.item_code
         AND sim.item_type = '002'
GROUP BY scirm.ORDER_NO, scird.item_code;