select 
    --*
    B.budget_book_id,
    B.description,
    B.from_date,
    B.to_dat,
    B.minimum_down_payment,
    B.interest,
    B.start_value,
    B.end_value,
    B.duration,
    B.payment_term_from,
    B.payment_term_to,
    B.tax1,
    B.tax2,
    B.tax3,
    B.hpnret_bb_sales_type_db,
    B.hpnret_bb_type_db,
    B.include_service_chg,
    B.grace_period,
    B.state
from HPNRET_BB_MAIN B
WHERE B.state = 'Opened'
