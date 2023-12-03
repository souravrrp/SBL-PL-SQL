select r.rule_no,
       t.template_id,
       t.line_no t_line_no,
       l.link_id,
       r.description,
       r.rule_type_no,
       r.amount,
       r.part,
       l.part_no,       
       l.channel,
       r.valid_from,
       r.valid_to,
       r.transaction_no,
       r.line_no r_line_no,
       r.mandotary
  from IFSAPP.HPNRET_RULE          r,
       IFSAPP.HPNRET_RULE_TEMP_DET t,
       IFSAPP.HPNRET_RULE_LINK     l
 where r.rule_no = t.rule_no
   and t.template_id = l.template_id
   /*and r.mandotary = 'TRUE'*/
   /*and \*sysdate*\to_date('2017/12/31', 'YYYY/MM/DD') between r.valid_from and r.valid_to*/
   and r.valid_from <= to_date('2016/12/31', 'YYYY/MM/DD')
   AND R.valid_to >= TO_DATE('2016/1/1', 'yyYY/mm/dd')
   and r.rule_type_no = /*'DISCOUNT'*/ 'FREE'   
   /*and r.part like \*'SRST-014'*\ '%ST-%'*/
   and l.channel in ('ALL', '24', '736', '762', '1142')
   /*and l.part_no \*= 'SRMO-SMW-30GCB6'*\ like 'PK%'*/
   /*and r.transaction_no = 2
   and r.line_no = 1*/
   /*and r.rule_no = 2131*/
   /*and t.template_id in (2133, 2134, 2149, 2150, 2151, 2152)*/
 order by /*1, 2, 4, 9*/6,8,9,4,13
