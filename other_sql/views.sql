create or replace view v_business as
select
    business_id ,"name" ,address ,city ,state ,postal_code ,
    cast (latitude as numeric) as latitude ,
    cast (longitude as numeric) as longitude ,
    cast (stars as numeric) as stars ,
    cast (review_count as int) as review_count ,
    cast (is_open as bool) as is_open ,
    "attributes", categories , hours 
from business b;

create or replace view v_checkin as
select
    business_id ,
    string_to_array (replace ("date", ', ',','), ',') as "date" 
from checkin c ;

create or replace view v_precipitation as
select
    "date"::date as "date" ,
    case when precipitation ~ '^([0-9]+\.?[0-9]*|\.[0-9]+)$' then cast (precipitation as numeric) end as precipitation ,
    cast (precipitation_normal as numeric)
from precipitation p ;

create or replace view v_review as
select
    review_id ,user_id ,business_id ,
    cast (stars as numeric) as stars ,
    cast (useful as int) as useful ,
    cast (funny as int) as funny ,
    cast (cool as int) as cool ,
    "text" , 
    cast ("date" as timestamp) as "date" 
from review r ;

create or replace view v_temperature as
select
    cast ("date" as date) as "date" ,
    cast ("min" as numeric) as "min" ,
    cast ("max" as numeric) as "max" ,
    cast (normal_min as numeric) as normal_min ,
    cast (normal_max as numeric) as normal_max 
from temperature t ;

create or replace view v_tip as
select
    user_id ,business_id ,"text" ,
    cast ("date" as timestamp) as "date" ,
    cast (compliment_count as int) as compliment_count
from tip t ;

create or replace view v_user as
select
    user_id ,"name" ,
    cast (review_count as int) as review_count ,
    cast (yelping_since as timestamp) as yelping_since ,
    cast (useful as int) as useful ,
    cast (funny as int) as funny ,
    cast (cool as int) as cool ,
    string_to_array (elite, ',') as elite ,
    string_to_array (replace (friends, ', ',','), ',') as friends ,
    cast (fans as int) as fans ,
    cast (average_stars as numeric) as average_stars ,
    cast (compliment_hot as int) as compliment_hot ,
    cast (compliment_more as int) as compliment_more ,
    cast (compliment_profile as int) as compliment_profile ,
    cast (compliment_cute  as int) as compliment_cute ,
    cast (compliment_list  as int) as compliment_list ,
    cast (compliment_note  as int) as compliment_note ,
    cast (compliment_plain  as int) as compliment_plain ,
    cast (compliment_cool as int) as compliment_cool ,
    cast (compliment_funny as int) as compliment_funny ,
    cast (compliment_writer as int) as compliment_writer ,
    cast (compliment_photos as int) as compliment_photos 
from "user" u ;

create materialized view mv_weather_x_review as
select
    sub_0."date", sub_0.total_stars, sub_0.avg_stars, sub_0.min_stars,
    sub_0.max_stars, vp.precipitation ,vp.precipitation_normal ,
    vt."min", vt."max", vt.normal_min , vt.normal_max 
from (
    select 
        cast ("date" as date) as "date" ,
        sum (stars) as total_stars ,
        avg (stars) as avg_stars ,
        min (stars) as min_stars ,
        max (stars) as max_stars
    from v_review vr 
    group by cast ("date" as date)) as sub_0
left join v_precipitation vp on sub_0."date" = vp."date" 
left join v_temperature vt on sub_0."date" = vt."date" 
order by 1;