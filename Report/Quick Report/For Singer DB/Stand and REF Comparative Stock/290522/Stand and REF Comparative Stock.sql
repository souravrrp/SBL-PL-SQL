/* Formatted on 5/29/2022 2:40:52 PM (QP5 v5.381) */
  SELECT i.contract,
         i.part_no,
         SUM (i.qty_onhand)     qty_onhand,
         'REF-' || i.part_no    REF_GROUP,
         NVL (
             (  SELECT SUM (i2.qty_onhand)
                  FROM IFSAPP.INVENTORY_PART_IN_STOCK i2
                 WHERE     i2.qty_onhand > 0
                       AND i2.contract = i.contract
                       AND i2.part_no IN
                               (SELECT l.part_no
                                  FROM IFSAPP.HPNRET_RULE       r,
                                       IFSAPP.HPNRET_RULE_TEMP_DET t,
                                       IFSAPP.HPNRET_RULE_LINK  l
                                 WHERE     r.rule_no = t.rule_no
                                       AND t.template_id = l.template_id
                                       AND r.mandotary = 'TRUE'
                                       AND SYSDATE BETWEEN r.valid_from
                                                       AND r.valid_to
                                       AND r.rule_type_no = 'FREE'
                                       AND r.part = i.part_no
                                       AND l.channel IN ('ALL', 24, 736)
                                       AND r.transaction_no = 2)
              GROUP BY i2.contract),
             0)                 REF_GROUP_qty_onhand
    FROM IFSAPP.INVENTORY_PART_IN_STOCK i
   WHERE     i.qty_onhand > 0
         AND i.contract LIKE '&shop_code'
         AND i.part_no IN
                 (SELECT DISTINCT (rr.part)
                    FROM IFSAPP.HPNRET_RULE         rr,
                         IFSAPP.HPNRET_RULE_TEMP_DET tt,
                         IFSAPP.HPNRET_RULE_LINK    ll
                   WHERE     rr.rule_no = tt.rule_no
                         AND tt.template_id = ll.template_id
                         AND rr.mandotary = 'TRUE'
                         AND TRUNC (SYSDATE) BETWEEN rr.valid_from
                                                 AND rr.valid_to
                         AND rr.rule_type_no = 'FREE'
                         AND rr.part LIKE '%ST-%'
                         AND ll.channel IN ('ALL', 24, 736)) /*('SRST-008', 'SRST-010', 'SRST-014', 'SRST-015')*/
GROUP BY i.contract, I.part_no
ORDER BY 1, 2;