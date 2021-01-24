import Foundation

struct Constants {
    static let apiKey: String = "fc9c89ecfea1b1278878383c2e559c99"
    static let imageURL: String = "https://image.tmdb.org/t/p/"
    
    struct MovieGroup {
        static let nowPlaying = "Now Playing"
        static let popular = "Popular"
        static let topRated = "Top Rated"
        static let upcoming = "Upcoming"
    }
    
    struct PosterSizes {
        static let w92 = "w92"
        static let w154 = "w154"
        static let w185 = "w185"
        static let w342 = "w342"
        static let w500 = "w500"
        static let w780 = "w780"
        static let original = "original"
    }
}
