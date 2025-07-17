import Foundation

struct Character: Decodable {
    let name: String
    let height: String
    let mass: String
    let birthYear: String
    let gender: String
    let homeworld: String

    enum CodingKeys: String, CodingKey {
        case name, height, mass, gender, homeworld
        case birthYear = "birth_year"
    }
}
