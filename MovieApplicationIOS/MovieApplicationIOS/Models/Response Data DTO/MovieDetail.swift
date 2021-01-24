import Foundation

struct MovieDetail: Codable {
    let adult: Bool
    let backdrop_path: String?
    let budget:Int
    let homepage: String
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Float
    let poster_path: String?
    let release_date: String
    let revenue: Int
    let runtime: Int
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
}
