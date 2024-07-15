import Foundation

struct AtmosphereComposition: Codable, Hashable {
    let element: String
    let percentage: Double
}

struct PlanetDTO: Codable {
    let id: Int
    let name: String
    let diameterKm: Int
    let averageTemperatureCelsius: Int
    let waterPercentage: Double
    let numberOfSatellites: Int
    let satellites: [String]
    let distanceFromSunKm: Int
    let orbitalPeriodDays: Double
    let rotationPeriodHours: Double
    let atmosphereComposition: [AtmosphereComposition]
    let description: String
    let scale: [Double]
    let order: Int
    let positionZ: Double
    let model3d: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, satellites, description, scale, order, model3d
        case diameterKm = "diameter_km"
        case averageTemperatureCelsius = "average_temperature_celsius"
        case waterPercentage = "water_percentage"
        case numberOfSatellites = "number_of_satellites"
        case distanceFromSunKm = "distance_from_sun_km"
        case orbitalPeriodDays = "orbital_period_days"
        case rotationPeriodHours = "rotation_period_hours"
        case atmosphereComposition = "atmosphere_composition"
        case positionZ = "position_z"
    }
}
