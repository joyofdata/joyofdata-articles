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

with 
tbl0 as (
    select a,b,t,v,
           locf(v) over t_asc as x1,
           locf(v) over t_desc as x2, 
           locf(case when v is not null then t else null end) 
                over t_desc as t2
    from tbl
    window t_asc as (partition by a,b order by t),
           t_desc as (partition by a,b order by t desc)
),
tbl1 as (
    select a,b,t,v,x1,x2,t2,
        case
            when 
                t2 != min(t) over imputed 
                and x1 is not null 
                and x2 is not null
            then 
                x1 + (
                    (x2 - x1)
                    *
                    (t - min(t) over imputed) /
                    (t2 - (min(t) over imputed))
                )
            else coalesce(x1,x2)
        end as v_final
    from tbl0
    window imputed as (partition by a,b,x1)
    order by a,b,t
)
select * from tbl1 order by a,b,t;

/*
-- use this instead of the last select above to
-- directly update the values in tbl.v

update tbl as tb
set v = t1.v_final
from t1
where
    tb.a = t1.a and tb.b = t1.b and tb.t = t1.t
;*/
