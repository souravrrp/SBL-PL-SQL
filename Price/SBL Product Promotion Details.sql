/* Formatted on 4/12/2023 2:02:55 PM (QP5 v5.381) */
SELECT a.description
           promotion_name,
       c.part_no
           product_name,
       a.rule_type_no,
       a.amount,
       a.part
           free_item_name,
       a.rule_no,
       --a.transaction_no hire_or_cash,
       CASE WHEN a.transaction_no = 1 THEN 'HIRE' ELSE 'CASH' END
           AS transaction_type,
       --or  decode(a.transaction_no,1,'HIRE',2,'CASH') Treansaction_Type,
       b.template_id,
       b.line_no,
       c.link_id,
       a.valid_from
           promotion_start_date,
       a.valid_to
           promotion_end_date,
       c.channel
  FROM ifsapp.hpnret_rule a, hpnret_rule_temp_det b, hpnret_rule_link c
 WHERE     a.rule_no = b.rule_no
       AND b.template_id = c.template_id
       AND NVL ( :p_date_from, a.valid_from) <= a.valid_from
       AND NVL ( :p_date_to, a.valid_to) >= a.valid_to
       AND (   :p_product_code IS NULL
            OR (UPPER (c.part_no) LIKE UPPER ('%' || :p_product_code || '%')))
       AND (   :p_promotion_name IS NULL
            OR (UPPER (a.description) LIKE
                    UPPER ('%' || :p_promotion_name || '%')))
       AND (   :p_channel IS NULL
            OR (UPPER (c.channel) LIKE UPPER ('%' || :p_channel || '%')))