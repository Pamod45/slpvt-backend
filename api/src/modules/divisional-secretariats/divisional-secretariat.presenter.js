export const formatDivisionalSecretariat = (ds) => ({
  ds_division_slug: ds.ds_division_slug,
  name: ds.name,
  province: {
    province_slug: ds.province_slug,
    name: ds.province_name
  },
  district: {
    district_slug: ds.district_slug,
    name: ds.district_name
  }
})
