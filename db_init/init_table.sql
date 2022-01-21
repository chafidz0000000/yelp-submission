create table if not exists business (
    "business_id" VARCHAR NULL, 
    "name" VARCHAR NULL, 
    "address" VARCHAR NULL, 
    "city" VARCHAR NULL, 
    "state" VARCHAR NULL, 
    "postal_code" VARCHAR NULL, 
    "latitude" VARCHAR NULL, 
    "longitude" VARCHAR NULL, 
    "stars" VARCHAR NULL, 
    "review_count" VARCHAR NULL, 
    "is_open" VARCHAR NULL, 
    "attributes" VARCHAR NULL, 
    "categories" VARCHAR NULL, 
    "hours" VARCHAR NULL
);
-- 
create table if not exists checkin (
    "business_id" VARCHAR NULL, 
    "date" VARCHAR NULL
);
--   
create table if not exists review (
    "review_id" VARCHAR NULL,
    "user_id" VARCHAR NULL,
    "business_id" VARCHAR NULL,
    "stars" VARCHAR NULL,
    "useful" VARCHAR NULL,
    "funny" VARCHAR NULL,
    "cool" VARCHAR NULL,
    "text" VARCHAR NULL,
    "date" VARCHAR NULL
);
--   
create table if not exists tip (
    "user_id" VARCHAR NULL,
    "business_id" VARCHAR NULL,
    "text" VARCHAR NULL,
    "date" VARCHAR NULL,
    "compliment_count" VARCHAR NULL
);
--   
create table if not exists "user" (
    "user_id" VARCHAR NULL,
    "name" VARCHAR NULL,
    "review_count" VARCHAR NULL,
    "yelping_since" VARCHAR NULL,
    "useful" VARCHAR NULL,
    "funny" VARCHAR NULL,
    "cool" VARCHAR NULL,
    "elite" VARCHAR NULL,
    "friends" VARCHAR NULL,
    "fans" VARCHAR NULL,
    "average_stars" VARCHAR NULL,
    "compliment_hot" VARCHAR NULL,
    "compliment_more" VARCHAR NULL,
    "compliment_profile" VARCHAR NULL,
    "compliment_cute" VARCHAR NULL,
    "compliment_list" VARCHAR NULL,
    "compliment_note" VARCHAR NULL,
    "compliment_plain" VARCHAR NULL,
    "compliment_cool" VARCHAR NULL,
    "compliment_funny" VARCHAR NULL,
    "compliment_writer" VARCHAR NULL,
    "compliment_photos" VARCHAR NULL
);
-- 
create table if not exists precipitation (
    "date" VARCHAR NULL,
    "precipitation" VARCHAR NULL,
    "precipitation_normal" VARCHAR NULL
);
-- 
create table if not exists temperature (
    "date" VARCHAR NULL,
    "min" VARCHAR NULL,
    "max" VARCHAR NULL,
    "normal_min" VARCHAR NULL,
    "normal_max" VARCHAR NULL
);
-- 
create index if not exists business_idx on business (
    "business_id"
);
-- 
create index if not exists checkin_idx on checkin (
    "business_id"
);
-- 
create index if not exists review_idx on review (
    "review_id",
    "user_id",
    "business_id"
);
-- 
create index if not exists tip_idx on tip (
    "user_id",
    "business_id"
);
-- 
create index if not exists user_idx on "user" (
    "user_id"
);
-- 
create index if not exists precipitation_idx on precipitation (
    "date"
);
-- 
create index if not exists temperature_idx on temperature (
    "date"
);
-- 
-- 
-- 
copy business (
    "business_id",
    "name",
    "address",
    "city",
    "state",
    "postal_code",
    "latitude",
    "longitude",
    "stars",
    "review_count",
    "is_open",
    "attributes",
    "categories",
    "hours"
) from '/data/yelp_academic_dataset_business.json.csv'
delimiter ','
quote '"'
csv header;
-- 
copy checkin (
    "business_id", 
    "date"
) from '/data/yelp_academic_dataset_checkin.json.csv'
delimiter ','
quote '"'
csv header;
-- 
copy review (
    "review_id",
    "user_id",
    "business_id",
    "stars",
    "useful",
    "funny",
    "cool",
    "text",
    "date"
) from '/data/yelp_academic_dataset_review.json.csv'
delimiter ','
quote '"'
csv header;
-- 
copy tip (
    "user_id",
    "business_id",
    "text",
    "date",
    "compliment_count"
) from '/data/yelp_academic_dataset_tip.json.csv'
delimiter ','
quote '"'
csv header;
-- 
copy "user" (
    "user_id",
    "name",
    "review_count",
    "yelping_since",
    "useful",
    "funny",
    "cool",
    "elite",
    "friends",
    "fans",
    "average_stars",
    "compliment_hot",
    "compliment_more",
    "compliment_profile",
    "compliment_cute",
    "compliment_list",
    "compliment_note",
    "compliment_plain",
    "compliment_cool",
    "compliment_funny",
    "compliment_writer",
    "compliment_photos"
) from '/data/yelp_academic_dataset_user.json.csv'
delimiter ','
quote '"'
csv header;
-- 
copy precipitation (
    "date",
    "precipitation",
    "precipitation_normal"
) from '/data/USW00023169-LAS_VEGAS_MCCARRAN_INTL_AP-precipitation-inch.csv'
delimiter ','
csv header;
-- 
copy temperature (
    "date",
    "min",
    "max",
    "normal_min",
    "normal_max"
) from '/data/USW00023169-temperature-degreeF.csv'
delimiter ','
csv header;