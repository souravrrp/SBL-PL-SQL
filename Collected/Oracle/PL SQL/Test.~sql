--*****
declare
  a integer := 10;
  b integer := 20;
  c integer;
  f real;
begin
  c := a + b;
  dbms_output.put_line('Value of c: ' || c);
  f := 90 / 3;
  dbms_output.put_line('Value of f: ' || f);
end;

--*****
declare
  n1 number(2, 0) := 95;
  n2 number(2, 1) := 9.5;
begin
  dbms_output.put_line('n1: ' || n1);
  dbms_output.put_line('n2: ' || n2);
  declare
    n1 number(3, 0) := 185;
    n2 number(3, 1) := 18.5;
  begin
    dbms_output.put_line('n1: ' || n1);
    dbms_output.put_line('n2: ' || n2);
  end;
end;

--*****Select into
declare
  p_code  SBL_JR_PRODUCT_DTL_INFO.PRODUCT_CODE%type;
  p_desc  SBL_JR_PRODUCT_DTL_INFO.PRODUCT_DESC%type;
  p_brand SBL_JR_PRODUCT_DTL_INFO.Brand%type;
  p_pf    SBL_JR_PRODUCT_DTL_INFO.Product_Family%type;
begin
  p_code := '&product_code';
  select p.product_code, p.product_desc, p.brand, p.product_family
    into p_code, p_desc, p_brand, p_pf
    from ifsapp.SBL_JR_PRODUCT_DTL_INFO p
   where p.product_code = p_code;
  dbms_output.put_line(p_code || ' means "' || p_desc || '" is of Brand "' ||
                       p_brand || '" & Product Family "' || p_pf || '".');
end;

--*****
declare
  --constant declaration
  pi constant number(10, 9) := 3.141592654;
  --other variable declaration
  radius        number(5, 2);
  diameter      number(5, 2);
  circumference number(7, 2);
  area          number(9, 2);

begin
  --calculation or processing
  radius        := '&radius';
  diameter      := radius * 2;
  circumference := 2 * pi * radius;
  area          := pi * radius ** 2 /* radius*/
   ;

  --output
  dbms_output.put_line('Radius: ' || radius);
  dbms_output.put_line('Diameter: ' || diameter);
  dbms_output.put_line('Circumference: ' || circumference);
  dbms_output.put_line('Area: ' || area);
end;

--*****Basic Loop
declare
  x number(5, 0) := 10;
begin
  loop
    dbms_output.put_line('In loop x: ' || x);
    x := x + 10;
    exit when x > 50;
  end loop;
  dbms_output.put_line('After exit x: ' || x);
end;

--*****While Loop
declare
  x number(2) := 10;
begin
  while x <= 20 loop
    dbms_output.put_line('In Loop x: ' || x);
    x := x + 1;
  end loop;
  dbms_output.put_line('Outside Loop x: ' || x);
end;

--*****For Loop
declare
  a number(2);
begin
  for a in 10 .. 20 loop
    dbms_output.put_line('Value of a: ' || a);
  end loop;
end;

--*****For Loop Reverse
declare
  a number(2);
begin
  for a in reverse 10 .. 20 loop
    dbms_output.put_line('Value of a: ' || a);
  end loop;
end;

--*****Nested Loop using For Loop Prime No 2 - 100
declare
  i number(3);
  j number(3);
begin
  <<outer_loop>>
  for i in 2 .. 100 loop
    <<inner_loop>>
    for j in 2 .. i loop
      /*dbms_output.put_line('In Inner Loop j: ' || j || ', i: ' || i);*/
      if j = i then
        dbms_output.put_line(i || ' is a prime.');
      end if;
      exit when mod(i, j) = 0;
    end loop inner_loop;
    /*dbms_output.put_line('After Inner Loop j: ' || j || ', i: ' || i);*/
  end loop outler_loop;
end;

--*****String Declaration
declare
  name         varchar2(20);
  company      varchar2(30);
  introduction clob;
  choice       char(1);
begin
  name         := 'Abu Kaiser';
  company      := 'Singer Bangladesh Ltd.';
  introduction := 'Hello! I''m Kaiser from IT.';
  choice       := 'y';
  if choice = 'y' then
    dbms_output.put_line(name);
    dbms_output.put_line(company);
    dbms_output.put_line(introduction);
  end if;
end;

--*****String Function
declare
  greetings varchar2(12) := 'Hello! World';
begin
  dbms_output.put_line(upper(greetings));
  dbms_output.put_line(lower(greetings));
  dbms_output.put_line(initcap(greetings));

  --retrieve the first character in the string
  dbms_output.put_line(substr(greetings, 1, 1));
  --retrieve the last character in the string
  dbms_output.put_line(substr(greetings, -1, 1));
  --retrieve five characters, starting from the eighth position
  dbms_output.put_line(substr(greetings, 8, 5));
  --retrieve the remainder of the string, starting from the second position
  dbms_output.put_line(substr(greetings, 2));
  --find the location of the 2nd 'l'
  dbms_output.put_line(instr(greetings, 'l', 1, 2));
end;

--*****String Function 2
declare
  greetings varchar2(30) := '.....Hello! World.....';
begin
  dbms_output.put_line(ltrim(greetings, '.'));
  dbms_output.put_line(rtrim(greetings, '.'));
  dbms_output.put_line(trim('.' from greetings));
end;

--*****Array - Varray
declare
  type namesarray is varray(5) of varchar2(10);
  type grades is varray(5) of integer;
  names namesarray;
  marks grades;
  total integer;
begin
  names := namesarray('Hozaifa', 'Bayzed', 'Rubel', 'Bablu', 'Laila');
  marks := grades(88, 86, 57, 78, 78);
  total := names.count;
  dbms_output.put_line('Total ' || total || ' Students.');
  for i in 1 .. total loop
    dbms_output.put_line('Student: ' || names(i) || ' Marks: ' || marks(i));
  end loop;
end;

--*****Varray using %type
declare
  cursor c_products is
    select p.product_code
      from IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
     where p.product_family = 'AIR-COOLER'
     order by p.product_code;
  type prod_list is varray(11) of SBL_JR_PRODUCT_DTL_INFO.Product_Code%type;
  pname_list prod_list := prod_list();
  counter    integer := 0;
begin
  for n in c_products loop
    counter := counter + 1;
    pname_list.extend;
    pname_list(counter) := n.product_code;
    dbms_output.put_line('Air Cooler(' || counter || '): ' ||
                         pname_list(counter));
  end loop;
end;
