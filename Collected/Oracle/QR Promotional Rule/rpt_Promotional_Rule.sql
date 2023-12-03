select a.description  Promotion_name,
       c.part_no      Product_Name,
       a.rule_type_no,
       a.amount,
       a.part         Free_Item_Name,
       a.rule_no,
       decode(a.transaction_no,1,'HIRE',2,'CASH') Treansaction_Type,
       b.template_id,
       b.line_no,
       c.link_id,
       to_char(a.valid_from, 'yyyy/mm/dd')  Promotion_start_date,
       to_char(a.valid_to, 'yyyy/mm/dd')    Promotion_end_date,
       c.channel
  from IFSAPP.HPNRET_RULE a, HPNRET_RULE_TEMP_DET b, HPNRET_RULE_LINK c
 where a.rule_no = b.rule_no
   and b.template_id = c.template_id
   and to_date('&VALID_FROM_DATE', 'yyyy/mm/dd') <= a.valid_to
   and to_date('&VALID_TO_DATE', 'yyyy/mm/dd') >= a.valid_from
   and c.part_no like '&PART_NO'
   and a.description like '&PROMOTION_NAME'
   and c.channel like '&CHANNEL_CODE'
 order by b.template_id, b.line_no, c.link_id
