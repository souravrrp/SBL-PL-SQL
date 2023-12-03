--------------------------------------------------------------------------------------------
--***** Check Data Status
SELECT *
  FROM IFSAPP.SBL_PAYING_PERCNTG_HIST P
 WHERE P.YEAR = '&year'
   AND P.PERIOD = '&period';

--truncate table  SBL_PAYING_PERCNTG_HIST
--PROCEDURE NAME: SBL_PAYING_PRCNTG_HIST_PRC(YEAR,PERIOD)

--***** Data Transfer Procedure
/*
begin
 SBL_PAYING_PRCNTG_HIST_PRC('&year','&period');
end;
*/
