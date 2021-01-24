import Foundation

struct MovieList: Codable {
    let page: Int
    let results: Array<MovieInformation>
    let total_pages: Int
    let total_results: Int
}
