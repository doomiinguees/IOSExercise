import Foundation

struct CharacterResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Character]
}
