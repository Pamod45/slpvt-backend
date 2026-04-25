/**
 * Stations seed
 * 39 stations across 4 hierarchy levels
 * 1  Police Headquarters — country level
 * 3  Range Offices       — provincial level (Western, Central, Southern)
 * 6  Main Stations       — district level
 * 29 Police Posts        — DS division level
 */

export const seed = async function (knex) {
  await knex('stations').del()

  const stationTypes = await knex('station_types').select('station_type_id', 'type_name')
  const t = {}
  stationTypes.forEach(st => {
    t[st.type_name] = st.station_type_id
  })

  const provinces = await knex('provinces').select('province_id', 'name')
  const p = {}
  provinces.forEach(prov => {
    p[prov.name] = prov.province_id
  })

  const districts = await knex('districts').select('district_id', 'name')
  const d = {}
  districts.forEach(dist => {
    d[dist.name] = dist.district_id
  })

  const dsDivisions = await knex('divisional_secretariats').select('ds_division_id', 'name')
  const ds = {}
  dsDivisions.forEach(div => {
    ds[div.name] = div.ds_division_id
  })

  await knex('stations').insert([

    // =========================================================
    // POLICE HEADQUARTERS — Country Level
    // =========================================================
    {
      name:             'Sri Lanka Police Headquarters',
      station_type_id:  t['Police Headquarters'],
      contact_number:   '+94112421111',
      latitude:         6.9271,
      longitude:        79.8612,
      ds_division_id:   null,
      district_id:      null,
      province_id:      null
    },

    // =========================================================
    // RANGE OFFICES — Provincial Level
    // =========================================================
    {
      name:             'Western Province Range Office',
      station_type_id:  t['Range Office'],
      contact_number:   '+94112300001',
      latitude:         6.9271,
      longitude:        79.8612,
      ds_division_id:   null,
      district_id:      null,
      province_id:      p['Western']
    },
    {
      name:             'Central Province Range Office',
      station_type_id:  t['Range Office'],
      contact_number:   '+94812200001',
      latitude:         7.2906,
      longitude:        80.6337,
      ds_division_id:   null,
      district_id:      null,
      province_id:      p['Central']
    },
    {
      name:             'Southern Province Range Office',
      station_type_id:  t['Range Office'],
      contact_number:   '+94912200001',
      latitude:         6.0535,
      longitude:        80.2210,
      ds_division_id:   null,
      district_id:      null,
      province_id:      p['Southern']
    },

    // =========================================================
    // MAIN STATIONS — District Level
    // =========================================================
    {
      name:             'Colombo District Main Station',
      station_type_id:  t['Main Station'],
      contact_number:   '+94112421001',
      latitude:         6.9344,
      longitude:        79.8428,
      ds_division_id:   null,
      district_id:      d['Colombo'],
      province_id:      null
    },
    {
      name:             'Gampaha District Main Station',
      station_type_id:  t['Main Station'],
      contact_number:   '+94332222001',
      latitude:         7.0873,
      longitude:        80.0144,
      ds_division_id:   null,
      district_id:      d['Gampaha'],
      province_id:      null
    },
    {
      name:             'Kalutara District Main Station',
      station_type_id:  t['Main Station'],
      contact_number:   '+94342222001',
      latitude:         6.5854,
      longitude:        79.9607,
      ds_division_id:   null,
      district_id:      d['Kalutara'],
      province_id:      null
    },
    {
      name:             'Kandy District Main Station',
      station_type_id:  t['Main Station'],
      contact_number:   '+94812222001',
      latitude:         7.2906,
      longitude:        80.6337,
      ds_division_id:   null,
      district_id:      d['Kandy'],
      province_id:      null
    },
    {
      name:             'Galle District Main Station',
      station_type_id:  t['Main Station'],
      contact_number:   '+94912222001',
      latitude:         6.0535,
      longitude:        80.2210,
      ds_division_id:   null,
      district_id:      d['Galle'],
      province_id:      null
    },
    {
      name:             'Matara District Main Station',
      station_type_id:  t['Main Station'],
      contact_number:   '+94412222001',
      latitude:         5.9549,
      longitude:        80.5550,
      ds_division_id:   null,
      district_id:      d['Matara'],
      province_id:      null
    },

    // =========================================================
    // POLICE POSTS — DS Division Level — Colombo District
    // =========================================================
    {
      name:             'Colombo Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112421002',
      latitude:         6.9271,
      longitude:        79.8612,
      ds_division_id:   ds['Colombo'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Dehiwala-MountLavinia Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112721001',
      latitude:         6.8517,
      longitude:        79.8653,
      ds_division_id:   ds['Dehiwala-MountLavinia'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Homagama Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112856001',
      latitude:         6.8428,
      longitude:        80.0022,
      ds_division_id:   ds['Homagama'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Kaduwela Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112537001',
      latitude:         6.9286,
      longitude:        79.9892,
      ds_division_id:   ds['Kaduwela'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Kesbewa Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112608001',
      latitude:         6.7967,
      longitude:        79.9331,
      ds_division_id:   ds['Kesbewa'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'SriJayawardanapuraKotte Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112865001',
      latitude:         6.9108,
      longitude:        79.8878,
      ds_division_id:   ds['SriJayawardanapuraKotte'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Thimbirigasyaya Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112696001',
      latitude:         6.8979,
      longitude:        79.8718,
      ds_division_id:   ds['Thimbirigasyaya'],
      district_id:      null,
      province_id:      null
    },

    // =========================================================
    // POLICE POSTS — DS Division Level — Gampaha District
    // =========================================================
    {
      name:             'Ja-Ela Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112231001',
      latitude:         7.0742,
      longitude:        79.8916,
      ds_division_id:   ds['Ja-Ela'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Kelaniya Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112911001',
      latitude:         7.0006,
      longitude:        79.9208,
      ds_division_id:   ds['Kelaniya'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Negombo Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94312222001',
      latitude:         7.2096,
      longitude:        79.8357,
      ds_division_id:   ds['Negombo'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Wattala Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94112939001',
      latitude:         6.9897,
      longitude:        79.8893,
      ds_division_id:   ds['Wattala'],
      district_id:      null,
      province_id:      null
    },

    // =========================================================
    // POLICE POSTS — DS Division Level — Kalutara District
    // =========================================================
    {
      name:             'Horana Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94342260001',
      latitude:         6.7156,
      longitude:        80.0631,
      ds_division_id:   ds['Horana'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Bandaragama Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94382290001',
      latitude:         6.7139,
      longitude:        79.9833,
      ds_division_id:   ds['Bandaragama'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Ingiriya Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94342290001',
      latitude:         6.7367,
      longitude:        80.1356,
      ds_division_id:   ds['Ingiriya'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Panadura Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94382222001',
      latitude:         6.7136,
      longitude:        79.9064,
      ds_division_id:   ds['Panadura'],
      district_id:      null,
      province_id:      null
    },

    // =========================================================
    // POLICE POSTS — DS Division Level — Kandy District
    // =========================================================
    {
      name:             'Medadumbara Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94812222002',
      latitude:         7.3667,
      longitude:        80.7167,
      ds_division_id:   ds['Medadumbara'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Minipe Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94812222003',
      latitude:         7.2833,
      longitude:        80.9167,
      ds_division_id:   ds['Minipe'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Thumpane Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94812222004',
      latitude:         7.3833,
      longitude:        80.5500,
      ds_division_id:   ds['Thumpane'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Udunuwara Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94812222005',
      latitude:         7.2167,
      longitude:        80.5833,
      ds_division_id:   ds['Udunuwara'],
      district_id:      null,
      province_id:      null
    },

    // =========================================================
    // POLICE POSTS — DS Division Level — Galle District
    // =========================================================
    {
      name:             'Ambalangoda Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94912258001',
      latitude:         6.2341,
      longitude:        80.0567,
      ds_division_id:   ds['Ambalangoda'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Baddegama Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94912292001',
      latitude:         6.1833,
      longitude:        80.1833,
      ds_division_id:   ds['Baddegama'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Balapitiya Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94912260001',
      latitude:         6.2667,
      longitude:        80.0333,
      ds_division_id:   ds['Balapitiya'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Elpitiya Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94912293001',
      latitude:         6.2833,
      longitude:        80.1667,
      ds_division_id:   ds['Elpitiya'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Hikkaduwa Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94912277001',
      latitude:         6.1395,
      longitude:        80.1054,
      ds_division_id:   ds['Hikkaduwa'],
      district_id:      null,
      province_id:      null
    },

    // =========================================================
    // POLICE POSTS — DS Division Level — Matara District
    // =========================================================
    {
      name:             'Devinuwara Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94412222002',
      latitude:         5.9333,
      longitude:        80.5667,
      ds_division_id:   ds['Devinuwara'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Dickwella Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94412283001',
      latitude:         5.9667,
      longitude:        80.7000,
      ds_division_id:   ds['Dickwella'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Mulatiyana Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94412247001',
      latitude:         6.1167,
      longitude:        80.5000,
      ds_division_id:   ds['Mulatiyana'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Pitabeddara Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94412248001',
      latitude:         6.0500,
      longitude:        80.5167,
      ds_division_id:   ds['Pitabeddara'],
      district_id:      null,
      province_id:      null
    },
    {
      name:             'Weligama Police Post',
      station_type_id:  t['Police Post'],
      contact_number:   '+94412250001',
      latitude:         5.9747,
      longitude:        80.4290,
      ds_division_id:   ds['Weligama'],
      district_id:      null,
      province_id:      null
    }
  ])
}