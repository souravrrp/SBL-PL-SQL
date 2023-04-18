/* Formatted on 3/6/2023 10:59:45 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.invoice_tab it
 WHERE     1 = 1
       --AND it.invoice_id IN (11041742, 11968706)
       AND (   :p_invoice_id IS NULL
            OR (UPPER (it.invoice_id) = UPPER ( :p_invoice_id)));

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.invoice_item_tab itt
 WHERE 1 = 1 
 AND C1 = 'SIS-R1043'
 ;

SELECT *
  FROM ifsapp.invoice_tab it
 WHERE 1 = 1 AND INVOICE_ID = 3236655;