--*****Aging Part Info
select 
    * 
    --distinct(v.part_no) part_no
from sbl_vw_product_aging v
where v.product_family in ('ACRAW') --'ACSPT', 'ACWD'
order by v.part_no


--*****Product Info
select 
    --*
    p.group_no,
    (select i.product_group from product_info i where i.group_no = p.group_no) product_group,
    p.product_code
from product_category_info p
where p.group_no = 130
--p.product_code like 'VNAC- VC-1824'

--*****
select * from product_info
