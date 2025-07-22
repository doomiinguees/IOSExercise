struct Film: Codable {
    let title: String
    let episodeId: Int
    let director: String
    let releaseDate: String

    private enum CodingKeys: String, CodingKey {
        case title
        case episodeId = "episode_id"
        case director
        case releaseDate = "release_date"
    }
}
