--*****15(a)
select case
         when null is null then
          'Yes'
         else
          'No'
       end "result"
  from dual;

--*****15(b)

--*****16
select extract(year from to_date('&s_date', 'YYYY/MM/DD')) "YEAR",
       extract(month from to_date('&s_date', 'YYYY/MM/DD')) "MONTH"
  from dual;
  
--*****17
/*ROWID is the psedo columns indicate the stored location of the data physically in the database.

Rowid is the physical address for each record in the database and it is a fixed-length binary data.
The format of the rowid is:
BBBBBBB.RRRR.FFFFF
where:
BBBBBBB is the block in the database file;
RRRR is the row in the block;
FFFFF is the database file. 

ROWID is nothing but the physical memory location on which that data/row is stored.ROWID basically returns address of row.
ROWID uniquely identifies row in database.
ROWID is combination of data object number,data block in datafile,position of row and datafile in which row resides.
ROWID is 16 digit hexadecimal number whose datatype is also ROWID Or UROWID
The fastest way to access a single row is ROWID
ROWID is unique identifier of the ROW.*/

--*****18
select t.user_id,
       (select u.user_name from users where u.user_id = t.user_id) user_name,
       t.training_date,
       count(t.training_id) count
  from training_details t
 group by u.user_id, t.training_date
having count(t.training_id) > 1
 order by t.training_date desc;
