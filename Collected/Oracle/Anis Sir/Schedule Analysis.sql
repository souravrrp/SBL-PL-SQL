--List of Scheduled Jobs & Reports
select *
  from IFSAPP.BATCH_SCHEDULE_TAB s
 where s.username = 'IFSAPP'
   and s.active = 'TRUE'
 order by 1;

--Methods of Listed Scheduled Jobs
select * from IFSAPP.BATCH_SCHEDULE_METHOD_TAB m order by 1;

--Archive of Executed Order Reports
select *
  from IFSAPP.ARCHIVE a
 where a.owner = 'IFSAPP'
   and TRUNC(a.exec_time) <= to_date('&exec_date', 'YYYY/MM/DD')
   and a.report_title like '%&report_title%'
 ORDER BY a.exec_time desc;

--List of Background Jobs
select *
  from IFSAPP.DEFERRED_JOB j
 where /*j.username = 'IFSAPP'*/
   /*and j.description like '%Schedule id 2286%'*/ --ID of Sales Analysis Report - Schedule
   /*and j.state = 'Posted'*/ --Posted, Executing, Ready, Error
   /*and*/ j.procedure_name = 'Scheduled_Report_API.Run__'
   and trunc(j.posted) <= to_date('&post_date', 'YYYY/MM/DD')
 order by j.started desc;

--Status of Background Jobs
select distinct t.state from DEFERRED_JOB t;
