import Foundation

struct MovieInformation: Codable {
    let poster_path: String?
    let adult: Bool
    let overview: String
    let release_date: String
    let genre_ids: Array<Int>
    let id: Int
    let original_title: String
    let original_language: String
    let title: String
    let backdrop_path: String?
    let popularity: Float
    let vote_count: Int
    let video: Bool
    let vote_average: Float
}
