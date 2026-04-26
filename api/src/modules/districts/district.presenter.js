export const formatDistrict = (district) => ({
  district_slug: district.district_slug,
  name: district.name,
  province: {
    province_slug: district.province_slug,
    name: district.province_name
  },
  ds_division_count: parseInt(district.ds_division_count || 0)
})
