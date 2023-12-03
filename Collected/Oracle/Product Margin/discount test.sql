select --l.part_no,
       --l.link_id,
       l.template_id--,
       /*(select t.rule_no                
         from IFSAPP.HPNRET_RULE_TEMP_DET t where t.template_id = l.template_id and t.line_no = 1) rule_no*/           
  from IFSAPP.HPNRET_RULE_LINK l
 where l.channel in ('ALL', 24) and
       l.part_no = 'GRTV-40VLE630BH'
   
select --t.template_id,
       t.rule_no,
       --t.line_no 
  from IFSAPP.HPNRET_RULE_TEMP_DET t
 where t.line_no = 1
   and t.template_id in (591, 723)

select r.rule_no,
       t.template_id,
       r.description,
       r.rule_type_no,
       l.part_no,
       r.amount,
       r.valid_from,
       r.valid_to,
       r.transaction_no,
       r.mandotary
  from IFSAPP.HPNRET_RULE r,
       IFSAPP.HPNRET_RULE_TEMP_DET t,
       IFSAPP.HPNRET_RULE_LINK l
 where r.rule_no = t.rule_no
   and t.template_id = l.template_id
   and r.rule_type_no = 'DISCOUNT'
   and r.valid_from <= to_date('&date', 'YYYY/MM/DD')
   and r.valid_to >= to_date('&date', 'YYYY/MM/DD')
   and r.mandotary = 'TRUE'
   and t.line_no = 1
   and l.channel in ('ALL', 24)
   and l.part_no like '%REF%'
order by l.part_no
