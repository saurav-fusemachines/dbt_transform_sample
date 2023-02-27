
    
with __dbt__cte__sample_users_contact_number_ab1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: "DataWareHouseX".public."sample_users"
select
    _airbyte_sample_users_hashid,
    jsonb_extract_path_text(contact_number, 'home') as home,
    jsonb_extract_path_text(contact_number, 'office') as office,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from "DataWareHouseX".public."sample_users" as table_alias
-- contact_number at sample_users/contact_number
where 1 = 1
and contact_number is not null
),  __dbt__cte__sample_users_contact_number_ab2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: __dbt__cte__sample_users_contact_number_ab1
select
    _airbyte_sample_users_hashid,
    cast(home as 
    float
) as home,
    cast(office as 
    float
) as office,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at
from __dbt__cte__sample_users_contact_number_ab1
-- contact_number at sample_users/contact_number
where 1 = 1
),  __dbt__cte__sample_users_contact_number_ab3 as (

-- SQL model to build a hash column based on the values of this record
-- depends_on: __dbt__cte__sample_users_contact_number_ab2
select
    md5(cast(coalesce(cast(_airbyte_sample_users_hashid as text), '') || '-' || coalesce(cast(home as text), '') || '-' || coalesce(cast(office as text), '') as text)) as _airbyte_contact_number_hashid,
    tmp.*
from __dbt__cte__sample_users_contact_number_ab2 tmp
-- contact_number at sample_users/contact_number
where 1 = 1
)-- Final base SQL model
-- depends_on: __dbt__cte__sample_users_contact_number_ab3
select
    _airbyte_sample_users_hashid,
    home,
    office,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_contact_number_hashid
from __dbt__cte__sample_users_contact_number_ab3
-- contact_number at sample_users/contact_number from "DataWareHouseX".public."sample_users"
where 1 = 1
