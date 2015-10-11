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
    locf(v) over t_asc as v_locf,
    locf(v) over t_desc as v_focb,
    coalesce(
        locf(v) over t_asc,
        locf(v) over t_desc
    ) as v_final
from tbl
window
    t_asc as (partition by a,b order by t),
    t_desc as (partition by a,b order by t desc)
order by a,b,t
;
