select * from TEMP_INVENTORY_PART_TAB;

delete from TEMP_INVENTORY_PART_TAB;
commit;

EXEC TRANSFER_TO_INVENTORY_PART('DSCP');
commit;

select * from TEMP_SALES_PART_TAB;

delete from TEMP_SALES_PART_TAB;
commit;

EXEC TRANSFER_TO_SALES_PART('DSCP');
commit;

EXEC CREATE_SalesPriceList('DSCP');
COMMIT;