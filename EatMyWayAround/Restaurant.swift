import Foundation

class Restaurant: Codable {
    var name: String
    var location: LocationDetails
    var cuisines: String
    var average_cost_for_two: Int
    var user_rating: Ratings
}

class LocationDetails: Codable {
    var address: String
}

class Ratings: Codable {
    var aggregate_rating: String
    var votes: String
}
