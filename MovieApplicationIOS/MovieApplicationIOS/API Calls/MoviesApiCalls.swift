import Foundation
import Moya
import PromiseKit

class MoviesApiCalls {
    
    let provider: MoyaProvider<MovieServiceMoya> = MoyaProvider<MovieServiceMoya>()
    
    func getMovieCredits(movieId: Int) -> Promise<MovieCredits> {
        let target: MovieServiceMoya = .getCredits(movieId: movieId)
        
        return PromiseKitWrapper.callAPI(provider: provider, target: target)
    }
    
    func getLatestMoviePromise() -> Promise<MovieDetail> {
        let target: MovieServiceMoya = .getLatestMovie
        
        return PromiseKitWrapper.callAPI(provider: provider, target: target)
    }
    
    func getMovieDetailsPromise(movieId: Int) -> Promise<MovieDetail> {
        let target: MovieServiceMoya = .getMovieDetails(movieId: movieId)

        return PromiseKitWrapper.callAPI(provider: provider, target: target)
    }
    
    func getNowPlayingMoviesPromise(page: Int) -> Promise<MovieList> {
        let target: MovieServiceMoya = .getNowPlaying(page: page)
        
        return PromiseKitWrapper.callAPI(provider: provider, target: target)
    }
    
    func getPopularMoviesPromise(page: Int) -> Promise<MovieList> {
        let target: MovieServiceMoya = .getPopularMovies(page: page)
        
        return PromiseKitWrapper.callAPI(provider: provider, target: target)
    }
    
    func getRecommendationBaseOnMovie(movieId: Int) -> Promise<MovieList> {
        let target: MovieServiceMoya = .getRecommendation(movieId: movieId)
        
        return PromiseKitWrapper.callAPI(provider: provider, target: target)
    }
    
    func getTopRatedMoviesPromise(page: Int) -> Promise<MovieList> {
        let target: MovieServiceMoya = .getTopRatedMovies(page: page)
        
        return PromiseKitWrapper.callAPI(provider: provider, target: target)
    }
    
    func getUpcomingMoviesPromise(page: Int) -> Promise<MovieList> {
        let target: MovieServiceMoya = .getUpcomingMovies(page: page)
        
        return PromiseKitWrapper.callAPI(provider: provider, target: target)
    }
}
