create or replace function locf_s(a float, b float)
returns float
language sql
as '
  select coalesce(b, a)
';

drop aggregate if exists locf(float);
create aggregate locf(float) (
  sfunc = locf_s,
  stype = float
);

with 
tbl0 as (
    select a, b, t, v,
           locf(v) over t_asc as v_locf,
           locf(v) over t_desc as v_focb, 
           locf(case when v is not null then t else null end) 
                over t_asc as t_locf,
           locf(case when v is not null then t else null end) 
                over t_desc as t_focb
    from tbl
    window t_asc as (partition by a,b order by t),
           t_desc as (partition by a,b order by t desc)
),
tbl1 as (
    select a, b, t, v, v_locf, v_focb, t_locf, t_focb,
        case
            when 
                t_focb != t_locf 
                and v_locf is not null 
                and v_focb is not null
            then 
                v_locf + (
                    (v_focb - v_locf)
                    *
                    (t - t_locf) /
                    (t_focb - t_locf)
                )
            else coalesce(v_locf, v_focb)
        end as v_final
    from tbl0
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
