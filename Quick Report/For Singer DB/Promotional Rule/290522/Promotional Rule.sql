/* Formatted on 5/29/2022 12:33:11 PM (QP5 v5.381) */
  SELECT a.description
             Promotion_name,
         c.part_no
             Product_Name,
         a.rule_type_no,
         a.amount,
         a.percentage,
         a.part
             Free_Item_Name,
         a.rule_no,
         DECODE (a.transaction_no,  1, 'HIRE',  2, 'CASH')
             Treansaction_Type,
         b.template_id,
         b.line_no,
         c.link_id,
         TO_CHAR (a.valid_from, 'yyyy/mm/dd')
             Promotion_start_date,
         TO_CHAR (a.valid_to, 'yyyy/mm/dd')
             Promotion_end_date,
         c.channel
    FROM IFSAPP.HPNRET_RULE a, HPNRET_RULE_TEMP_DET b, HPNRET_RULE_LINK c
   WHERE     a.rule_no = b.rule_no
         AND b.template_id = c.template_id
         AND TO_DATE ('&VALID_FROM_DATE', 'yyyy/mm/dd') <= a.valid_to
         AND TO_DATE ('&VALID_TO_DATE', 'yyyy/mm/dd') >= a.valid_from
         AND c.part_no LIKE '&PART_NO'
         AND a.description LIKE '&PROMOTION_NAME'
         AND c.channel LIKE '&CHANNEL_CODE'
ORDER BY b.template_id, b.line_no, c.link_id;