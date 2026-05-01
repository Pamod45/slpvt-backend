export const format = (row) => {
  const location = {}

  if (row.ds_division_name) {
    location.ds_division = { name: row.ds_division_name, ds_division_slug: row.ds_division_slug }
  }
  if (row.district_name) {
    location.district = { name: row.district_name, district_slug: row.district_slug }
  }
  if (row.province_name) {
    location.province = { name: row.province_name, province_slug: row.province_slug }
  }

  return {
    short_code: row.short_code,
    station_type: row.station_type,
    name: row.name,
    contact_number: row.contact_number,
    coordinates: {
      latitude: row.latitude,
      longitude: row.longitude
    },
    location
  }
}
