const STALE_THRESHOLD_MS = 10 * 60 * 1000 // 10 minutes

const formatCoordinates = (ping) => {
  const [longitude, latitude] = ping.location.coordinates
  return {
    coordinates: {
      latitude,
      longitude
    },
    battery_level: ping.battery_level,
    pinged_at:     ping.pinged_at,
    is_stale:      (Date.now() - new Date(ping.pinged_at).getTime()) > STALE_THRESHOLD_MS
  }
}

export const formatLiveLocation = (ping) => formatCoordinates(ping)

export const formatHistoryPing = (ping) => {
  const [longitude, latitude] = ping.location.coordinates
  return {
    coordinates:   { latitude, longitude },
    battery_level: ping.battery_level,
    pinged_at:     ping.pinged_at
  }
}

export const formatLiveLocationWithVehicle = (ping, vehicle) => ({
  registration_number: vehicle.registration_number,
  police_status:       vehicle.police_status,
  ...formatCoordinates(ping)
})
