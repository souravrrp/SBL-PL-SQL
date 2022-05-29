/* Formatted on 5/26/2022 2:04:21 PM (QP5 v5.381) */
  SELECT s.contracT
             shop_code,
         description,
         TO_CHAR (SYSDATE, 'dd-MON-YY')
             Today,
         SUM (DECODE (status,  'Active', 1,  'Invoiced', 1))
             active_Invoiced,
         SUM (DECODE (status, 'PartiallyActive', 1))
             PartiallyActive,
         SUM (DECODE (status, 'Picked', 1))
             Picked,
         SUM (DECODE (status, 'Planned', 1))
             Planned,
         SUM (DECODE (status, 'Released', 1))
             Released,
         SUM (DECODE (status, 'Reserved', 1))
             Reserved,
         SUM (DECODE (status,  'Cancelled', 1,  'Closed', 1))
             other,
         COUNT (*)
             Total
    FROM hhh_invoice_status q, site s
   WHERE SUBSTR (q.account_no, 1, 3) = SUBSTR (s.contract, 1, 3)
GROUP BY s.contracT, description, TO_CHAR (SYSDATE, 'dd-MON-YY')