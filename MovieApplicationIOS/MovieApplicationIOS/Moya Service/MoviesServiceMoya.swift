import Foundation
import Moya

enum MovieServiceMoya {
    case getCredits(movieId: Int)
    case getLatestMovie
    case getMovieDetails(movieId: Int)
    case getNowPlaying(page: Int)
    case getPopularMovies(page: Int)
    case getRecommendation(movieId: Int)
    case getTopRatedMovies(page: Int)
    case getUpcomingMovies(page: Int)
}

extension MovieServiceMoya: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/movie")!
    }
    
    var path: String {
        switch self {
        case let .getCredits(movieId):
            return "/\(movieId)/credits"
        case .getLatestMovie:
            return "/latest"
        case let .getMovieDetails(movieId):
            return "/\(movieId)"
        case .getNowPlaying(_):
            return "/now_playing"
        case .getPopularMovies(_):
            return "/popular"
        case let .getRecommendation(movieId):
            return "/\(movieId)/recommendations"
        case .getTopRatedMovies(_):
            return "/top_rated"
        case .getUpcomingMovies(_):
            return "/upcoming"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCredits, .getLatestMovie, .getMovieDetails, .getNowPlaying, .getPopularMovies, .getRecommendation, .getTopRatedMovies, .getUpcomingMovies:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getCredits:
            return .requestParameters(parameters: ["api_key" : Constants.apiKey], encoding: URLEncoding.default)
        case .getLatestMovie:
            return .requestParameters(parameters: ["api_key" : Constants.apiKey], encoding: URLEncoding.default)
        case .getMovieDetails:
            return .requestParameters(parameters: ["api_key" : Constants.apiKey], encoding: URLEncoding.default)
        case let .getNowPlaying(page):
            return .requestParameters(parameters: ["api_key" : Constants.apiKey, "page" : page], encoding: URLEncoding.default)
        case let .getPopularMovies(page):
            return .requestParameters(parameters: ["api_key" : Constants.apiKey, "page" : page], encoding: URLEncoding.default)
        case .getRecommendation:
            return .requestParameters(parameters: ["api_key" : Constants.apiKey], encoding: URLEncoding.default)
        case let .getTopRatedMovies(page):
            return .requestParameters(parameters: ["api_key" : Constants.apiKey, "page" : page], encoding: URLEncoding.default)
        case let .getUpcomingMovies(page):
            return .requestParameters(parameters: ["api_key" : Constants.apiKey, "page" : page], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}
