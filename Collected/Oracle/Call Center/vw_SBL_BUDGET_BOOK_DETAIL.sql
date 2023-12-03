CREATE OR REPLACE VIEW SBL_BUDGET_BOOK_DETAIL AS
SELECT budget_book_id                 budget_book_id, 
       budget_line_no                 budget_line_no, 
       cash_price                     cash_price, 
       amount_financed                amount_financed, 
       gross_hire_value6              gross_hire_value6, 
       gross_hire_value9              gross_hire_value9, 
       gross_hire_value12             gross_hire_value12, 
       gross_hire_value15             gross_hire_value15, 
       gross_hire_value18             gross_hire_value18, 
       gross_hire_value21             gross_hire_value21, 
       gross_hire_value24             gross_hire_value24 
FROM   ifsapp.hpnret_bb_main_detail_tab
WHERE  budget_book_id IN ('NM-6', 'GR-19', 'GR-20','NM-23');
