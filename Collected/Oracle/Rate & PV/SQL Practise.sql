select * from employees;

--explict cursor with loop and fetch
declare
   empid employees.employee_id%type;
   efname employees.first_name%type;
   elname employees.last_name%type;
   ejobid employees.job_id%type;
   cursor c1 is
          select employee_id, first_name, last_name, job_id from employees; --where job_id = 'IT_PROG';

begin
  open c1;
  loop
    fetch c1 into empid, efname, elname, ejobid;
    exit when c1%notfound;
    if ejobid = 'IT_PROG' then
      dbms_output.put_line ('ID: '||empid||', First Name: '||efname||', Last Name: '||elname||'.');
    end if;
  end loop;
  
  /*if c1%isopen then
    dbms_output.put_line('Cursor is open.');*/
    close c1;
  /*else
    dbms_output.put_line('Cursor is closed.');
  end if;*/
  
end;


-- explicit cursor using for loop
declare 
  cursor c1 is
      select employee_id, first_name, last_name, job_id from employees;
  
begin
  for i in c1 loop
    if i.job_id = 'IT_PROG' then
      dbms_output.put_line ('ID: '||i.employee_id||', First Name: '||i.first_name||', Last Name: '||i.last_name||'.');
    end if;
  end loop;
  
  if c1%isopen then
    dbms_output.put_line('Cursor is open.');
    close c1;
  else
    dbms_output.put_line('Cursor is closed.');
  end if;
end;
