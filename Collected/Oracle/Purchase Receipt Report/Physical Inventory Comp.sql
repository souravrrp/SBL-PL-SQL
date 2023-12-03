select /*(select p.product_group 
          from SBL_PRODUCT_INFO p
          where p.group_no = (select c.group_no 
            from SBL_PRODUCT_CATEGORY_INFO c
            where c.product_code = rc.product_code)) PRODUCT_CATEGORY,*/
    rc.shop_code,
    rc.product_code,    
    sum(rc.quantity) qty_received
from REC_AFTER_CUT_OFF_TBL rc
where /*rc.product_code in (select c.product_code 
                    from SBL_PRODUCT_CATEGORY_INFO c 
                    where c.group_no in (select p.group_no 
                                        from SBL_PRODUCT_INFO p)) and*/
                                        rc.shop_code = 'DMDB' --and
                                        --rc.received_date between to_date('&fromDate', 'YYYY/MM/DD') and to_date('&toDate', 'YYYY/MM/DD')
group by rc.shop_code, rc.product_code
order by rc.shop_code, /*PRODUCT_CATEGORY,*/ rc.product_code
