create or replace function fun(a float, b float)
returns float
language sql
as '
  SELECT COALESCE(b, a)
';

select a,b,t,v,
    fun(t,v) as v_or_t
from tbl
order by a,b,t
;
