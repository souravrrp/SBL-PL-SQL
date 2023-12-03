--job status
select * from user_scheduler_jobs;
select * from user_scheduler_job_log tt order by tt.LOG_DATE desc;  -- schedule jobs details 
select * from user_scheduler_job_run_details;
select * from user_scheduler_job_args;
--for admin DBA
select * from DBA_SCHEDULER_JOBS;
select * from dba_scheduler_jobs ;
select * from dba_scheduler_job_log;  -- schedule jobs details 
select * from dba_scheduler_job_run_details;
select * from dba_scheduler_job_args;
