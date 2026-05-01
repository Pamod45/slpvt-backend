export const formatProvince = (province) => ({
  province_slug: province.province_slug,
  name: province.name,
  district_count: parseInt(province.district_count || 0)
})
