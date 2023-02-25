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
from 
sample_users from "DataWareHouseX".public.sample_users
  );
