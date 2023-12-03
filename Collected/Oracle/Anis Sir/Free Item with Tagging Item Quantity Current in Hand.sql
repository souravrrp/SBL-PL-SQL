--Free Item with Tagging Item quantity current in hand
select i.contract,
       i.part_no,
       sum(i.qty_onhand) qty_onhand,
       'REF-' || i.part_no REF_GROUP,
       nvl((select sum(i2.qty_onhand)
             from IFSAPP.INVENTORY_PART_IN_STOCK i2
            where i2.qty_onhand > 0
              and i2.contract = i.contract
              and i2.part_no in
                  (select l.part_no
                     from IFSAPP.HPNRET_RULE          r,
                          IFSAPP.HPNRET_RULE_TEMP_DET t,
                          IFSAPP.HPNRET_RULE_LINK     l
                    where r.rule_no = t.rule_no
                      and t.template_id = l.template_id
                      and r.mandotary = 'TRUE'
                      and sysdate between r.valid_from and r.valid_to
                      and r.rule_type_no = 'FREE'
                      and r.part = i.part_no
                      and l.channel in ('ALL', 24, 736)
                      and r.transaction_no = 2)
            group by i2.contract),
           0) REF_GROUP_qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 where i.qty_onhand > 0
   and i.part_no in (select distinct (rr.part)
                       from IFSAPP.HPNRET_RULE          rr,
                            IFSAPP.HPNRET_RULE_TEMP_DET tt,
                            IFSAPP.HPNRET_RULE_LINK     ll
                      where rr.rule_no = tt.rule_no
                        and tt.template_id = ll.template_id
                        and rr.mandotary = 'TRUE'
                        and sysdate between rr.valid_from and rr.valid_to
                        and rr.rule_type_no = 'FREE'
                        and rr.part LIKE '%ST-%'
                        and ll.channel in ('ALL', 24, 736)) /*('SRST-008', 'SRST-010', 'SRST-014', 'SRST-015')*/
 group by i.contract, I.part_no
 ORDER BY 1, 2


--Tagging Item for Free quantity reconciliation
select i2.contract, sum(i2.qty_onhand)
  from IFSAPP.INVENTORY_PART_IN_STOCK i2
 where i2.qty_onhand > 0
   and i2.contract = 'AKHB'
   and i2.part_no in (select l.part_no
                        from IFSAPP.HPNRET_RULE          r,
                             IFSAPP.HPNRET_RULE_TEMP_DET t,
                             IFSAPP.HPNRET_RULE_LINK     l
                       where r.rule_no = t.rule_no
                         and t.template_id = l.template_id
                         and r.mandotary = 'TRUE'
                         and sysdate between r.valid_from and r.valid_to
                         and r.rule_type_no = 'FREE'
                         and r.part = 'SRST-014'
                         and l.channel in ('ALL', 24, 736)
                         and r.transaction_no = 2)
 group by i2.contract
