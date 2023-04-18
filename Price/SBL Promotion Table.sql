/* Formatted on 4/13/2023 12:06:14 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.hpnret_rule_type_tab hrtt
 WHERE 1 = 1;


SELECT *
  FROM hpnret_rule_tab hrt
 WHERE 1 = 1
 AND (   :p_promotion_name IS NULL
            OR (UPPER (hrt.description) LIKE
                    UPPER ('%' || :p_promotion_name || '%')));


--------------------------------------------------------------------------------

  SELECT *
    FROM ifsapp.hpnret_rule
   WHERE 1 = 1
ORDER BY rule_no;

SELECT *
  FROM ifsapp.hpnret_rule_type hrt;

SELECT *
  FROM ifsapp.hpnret_rule_template
 WHERE 1 = 1;

SELECT *
  FROM ifsapp.hpnret_rule_link
 WHERE 1 = 1;

--------------------------------Promotion--------------------------------------

SELECT *
  FROM ifsapp.sbl_discount_promotion sdp
 WHERE 1 = 1;

--------------------------------Commission--------------------------------------

SELECT *
  FROM ifsapp.commission_agree_line_tab calt
 WHERE 1 = 1;