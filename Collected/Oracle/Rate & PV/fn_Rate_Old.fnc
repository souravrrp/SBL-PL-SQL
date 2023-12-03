create or replace function fn_Rate(
       nper in number, 
       pmt in number, 
       pv number)
       --fv in number)
return number
is
  i NUMBER(16,6);
  tolerance NUMBER(16,6) := 0.00001;
  step NUMBER(16,6) := 0.000001;
  maxIterations INT := 100000;
  guess NUMBER(16,6) := 0.1;
  --compareFV NUMBER := 0.0;
  comparePV number(16,6) := 0.0;
  iteration INT := 0;

begin

  /*i := guess;
  WHILE (iteration < maxIterations)LOOP
    IF compareFV > fv * (1 + tolerance) OR compareFV < fv * (1 - tolerance) THEN
      IF compareFV > fv THEN
        i := i - step; --If the guess is high, decrement for this round
      ELSE
        i := i + step; --If the guess is low, increment for this round
      END IF;
      
      iteration := iteration + 1;
      --Formula of Future Value
      compareFV := (pmt * ((POWER((1 + i), nper) - 1)/i));
    ELSE
      EXIT; --If we have hit the target, leave the loop and return
    end if;
  END LOOP;*/
  
  i := guess;
  WHILE (iteration < maxIterations)LOOP
    IF comparePV > pv * (1 + tolerance) OR comparePV < pv * (1 - tolerance) THEN
      IF comparePV > pv THEN
        i := i + step; --If the guess is high, decrement for this round
      ELSE
        i := i - step; --If the guess is low, increment for this round
      END IF;
      
      iteration := iteration + 1;
      --Formula of Present Value
      comparePV := pmt * ((1 - power((1 + i), -nper)) / i);
    ELSE
      EXIT; --If we have hit the target, leave the loop and return
    end if;
  END LOOP;


  -- Return the result of the function
  RETURN i;

exception
  when zero_divide then
    dbms_output.put_line('Interest rate is less than zero.');
    return 0.0;

end fn_Rate;
/
