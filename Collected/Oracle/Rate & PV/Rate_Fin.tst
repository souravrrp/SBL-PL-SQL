PL/SQL Developer Test script 3.0
34
-- Created on 7/29/2013 by ASDSAD 
declare 
  -- Local variables here
  --i integer;
  pv number := 8000.0;
  pmt number := 200.0;
  nper integer := 48;
  fv number := 11561.68;
  i NUMBER;
  tolerance NUMBER := 0.001;
  step NUMBER := 0.0001;
  maxIterations INT := 1000;
  guess NUMBER := 0.1;
  compareFV NUMBER := 0.0;
  iteration INT := 0;
begin
  -- Test statements here
  i := guess;
  WHILE (iteration < maxIterations)LOOP
    IF compareFV > fv * (1 + tolerance) OR compareFV < fv * (1 - tolerance) THEN
      IF compareFV > fv THEN
        i := i - step; --If the guess is high, decrement for this round
      ELSE
        i := i + step; --If the guess is low, increment for this round
      END IF;
      
      iteration := iteration + 1;
      compareFV := -(pv * POWER((1 + i), nper) + (pmt * ((POWER((1 + i), nper) - 1)/i)));
    ELSE
      EXIT; --BREAK --If we have hit the target, leave the loop and return
    end if;
  END LOOP;
  dbms_output.put_line(i);
end;
3
i
0
0
compareFV
0
0
iteration
0
0
3
i
compareFV
iteration
