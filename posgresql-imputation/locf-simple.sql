create or replace function locf_s(a float, b float)
returns float
language sql
as '
  SELECT COALESCE(b, a)
';

drop aggregate if exists locf(float);
create aggregate locf(float) (
  sfunc = locf_s,
  stype = float
);

select a,b,t,v,
    locf(v) over (partition by a,b order by t) as v_locf
from tbl
order by a,b,t
;
