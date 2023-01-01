SELECT u.username, CONCAT(u.firstname, ' ', u.lastname) AS full_name, u.department,
GROUP_CONCAT(DISTINCT ch.idnumber SEPARATOR '|') AS cohorts,uinfo.`data` AS location, cc.idnumber as `channel`,
(select idnumber from mdl_course_categories where id = cor.category) as category, cor.shortname AS course,

(SELECT COUNT(*)  FROM mdl_course_modules
WHERE course= cm.course
GROUP BY course) AS total_topic,

(SELECT COUNT(*) AS completed FROM mdl_course_completion_crit_compl
WHERE course = cm.course AND userid=com.userid
GROUP BY course) AS total_completed,

ROUND((SELECT COUNT(*) AS completed FROM mdl_course_completion_crit_compl
WHERE course = cm.course AND userid=com.userid
GROUP BY course) * 100.0 / (SELECT COUNT(*)  FROM mdl_course_modules
WHERE course= cm.course
GROUP BY course), 1) AS percent,

(select FROM_UNIXTIME(timecreated, '%d-%M-%Y %H:%i:%s') AS timecreated
from mdl_user_enrolments where userid=com.userid AND enrolid=(select id from mdl_enrol where enrol='manual' and courseid=com.course)) as enrolled,

(CASE WHEN com.timestarted=0 THEN NULL ELSE FROM_UNIXTIME(com.timestarted, '%d-%M-%Y %H:%i:%s')END) AS started

FROM mdl_course_completions AS com, mdl_course AS cor, mdl_user AS u, mdl_course_modules AS cm, 
mdl_cohort AS ch, mdl_cohort_members AS chm, mdl_user_info_data AS uinfo, mdl_course_categories as cc

WHERE com.course=cor.id AND com.userid=u.id AND cm.course=cor.id AND ch.id=chm.cohortid AND chm.userid=u.id
AND cc.id=(select (CASE WHEN depth=1 then id else REPLACE(SUBSTRING_INDEX(path, '/',2), '/', '') END) as parent_cat
from mdl_course_categories where id=cor.category)
AND com.timecompleted is null
AND uinfo.userid=u.id AND uinfo.fieldid=1

GROUP BY com.id, com.course
ORDER BY com.course ASC;