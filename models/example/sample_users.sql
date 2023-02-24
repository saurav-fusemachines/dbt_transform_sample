  create  table "DataWareHouseX".public."sample_users__dbt_tmp"
  as (
    
with __dbt__cte__sample_users_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "DataWareHouseX".public._airbyte_raw_sample_users
select
    jsonb_extract_path_text(_airbyte_data, '_id') as _id,
    jsonb_extract_path_text(_airbyte_data, 'age') as age,
    jsonb_extract_path_text(_airbyte_data, 'name') as "name",
    jsonb_extract_path_text(_airbyte_data, 'email') as email,
    jsonb_extract_path_text(_airbyte_data, 'location') as "location",
    
        jsonb_extract_path(table_alias._airbyte_data, 'contact_number')
     as contact_number,
    jsonb_extract_path_text(_airbyte_data, 'eid_aibyte_transform') as eid_aibyte_transform,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "DataWareHouseX".public._airbyte_raw_sample_users as table_alias
-- sample_users
where 1 = 1
),  __dbt__cte__sample_users_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__sample_users_ab1
select
    cast(_id as text) as _id,
    cast(age as 
    float
) as age,
    cast("name" as text) as "name",
    cast(email as text) as email,
    cast("location" as text) as "location",
    cast(contact_number as 
    jsonb
) as contact_number,
    cast(eid_aibyte_transform as text) as eid_aibyte_transform,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__sample_users_ab1
-- sample_users
where 1 = 1
),  __dbt__cte__sample_users_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__sample_users_ab2
select
    md5(cast(coalesce(cast(_id as text), '') || '-' || coalesce(cast(age as text), '') || '-' || coalesce(cast("name" as text), '') || '-' || coalesce(cast(email as text), '') || '-' || coalesce(cast("location" as text), '') || '-' || coalesce(cast(contact_number as text), '') || '-' || coalesce(cast(eid_aibyte_transform as text), '') as text)) as _airbyte_sample_users_hashid,
    tmp.*
from __dbt__cte__sample_users_ab2 tmp
-- sample_users
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__sample_users_ab3
select
    _id,
    age,
    Upper("name"),
    email,
    "location",
    contact_number,
    eid_aibyte_transform,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_sample_users_hashid
from __dbt__cte__sample_users_ab3
-- sample_users from "DataWareHouseX".public._airbyte_raw_sample_users
where 1 = 1
  );
