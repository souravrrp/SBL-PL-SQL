create or replace view SBL_DISCOUNT_PROMOTION as
  select r.rule_no,
         t.template_id,
         t.line_no        t_line_no,
         l.link_id,
         r.description,
         r.rule_type_no,
         r.amount,
         l.part_no,
         l.channel,
         r.valid_from,
         r.valid_to,
         r.transaction_no,
         r.line_no        r_line_no,
         r.mandotary
    from IFSAPP.HPNRET_RULE          r,
         IFSAPP.HPNRET_RULE_TEMP_DET t,
         IFSAPP.HPNRET_RULE_LINK     l
   where r.rule_no = t.rule_no
     and t.template_id = l.template_id
     and r.rule_type_no = 'DISCOUNT'
     and r.mandotary = 'TRUE'
     and l.channel in ('ALL', '24', '736', '2048')
