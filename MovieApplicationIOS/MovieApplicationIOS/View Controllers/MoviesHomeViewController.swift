import UIKit
import PromiseKit
import SDWebImage

@available(iOS 13.0, *)
class MoviesHomeViewController: UIViewController {
    
    let moviesAPICalls = MoviesApiCalls()
    
    var latestMovieDetail: MovieDetail?
    var movieData: MovieInformation?
    var moviePosterImage: UIImage?
    
    var upcomingMovies: MovieList?
    var upcomingMoviesList = [MovieInformation]()
    var upComingMoviesPage: Int = 1
    
    var nowPlayingMovies: MovieList?
    var nowPlayingMoviesList = [MovieInformation]()
    var nowPlayingMoviesPage: Int = 1
    
    var popularMovies: MovieList?
    var popularMoviesList = [MovieInformation]()
    var popularMoviesPage: Int = 1
    
    var topRatedMovies: MovieList?
    var topRatedMoviesList = [MovieInformation]()
    var topRatedMoviesPage: Int = 1
    
    @IBOutlet weak var moviesHomeTableView: UITableView!
    @IBAction func btnHome(_ sender: UIButton) {
        moviesHomeTableView.setContentOffset(.zero, animated: false)
    }
    @IBAction func unwindToMoviesHomeViewController(_ seg: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moviesHomeTableView.register(LatestMovieTableViewCell.nib(), forCellReuseIdentifier: LatestMovieTableViewCell.identifier)
        moviesHomeTableView.register(MoviesListTableViewCell.nib(), forCellReuseIdentifier: MoviesListTableViewCell.identifier)
        moviesHomeTableView.register(NowPlayingMoviesTableViewCell.nib(), forCellReuseIdentifier: NowPlayingMoviesTableViewCell.identifier)
        moviesHomeTableView.delegate = self
        moviesHomeTableView.dataSource = self
        

        getLatestMovie()
        getUpcomingMovies(page: upComingMoviesPage)
        getNowPlayingMovies(page: nowPlayingMoviesPage)
        getPopularMovies(page: popularMoviesPage)
        getTopRatedMovies(page: topRatedMoviesPage)
        
        self.moviesHomeTableView.estimatedRowHeight = 0;
        self.moviesHomeTableView.estimatedSectionHeaderHeight = 0;
        self.moviesHomeTableView.estimatedSectionFooterHeight = 0;
        
    }
    
    func getLatestMovie() {
        firstly {
            moviesAPICalls.getLatestMoviePromise()
        }
        .ensure {
            
        }
        .done { latestMovieDetail in
            self.latestMovieDetail = latestMovieDetail
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getNowPlayingMovies(page: Int) {
        firstly {
            moviesAPICalls.getNowPlayingMoviesPromise(page: page)
        }
        .ensure {
            
        }
        .done { nowPlayingMovies in
            self.nowPlayingMovies = nowPlayingMovies
            self.nowPlayingMoviesPage = nowPlayingMovies.page
            self.nowPlayingMoviesList = self.nowPlayingMoviesList + nowPlayingMovies.results
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getPopularMovies(page: Int) {
        firstly {
            moviesAPICalls.getPopularMoviesPromise(page: page)
        }
        .ensure {
            
        }
        .done { popularMovies in
            self.popularMovies = popularMovies
            self.popularMoviesPage = popularMovies.page
            self.popularMoviesList = self.popularMoviesList + popularMovies.results
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getTopRatedMovies(page: Int) {
        firstly {
            moviesAPICalls.getTopRatedMoviesPromise(page: page)
        }
        .ensure {
            
        }
        .done { topRatedMovies in
            self.topRatedMovies = topRatedMovies
            self.topRatedMoviesPage = topRatedMovies.page
            self.topRatedMoviesList = self.topRatedMoviesList + topRatedMovies.results
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getUpcomingMovies(page: Int) {
        firstly {
            moviesAPICalls.getUpcomingMoviesPromise(page: page)
        }
        .ensure {
            
        }
        .done { upcomingMovies in
            self.upcomingMovies = upcomingMovies
            self.upComingMoviesPage = upcomingMovies.page
            self.upcomingMoviesList = self.upcomingMoviesList + upcomingMovies.results
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MovieDetailsViewController {
            let movieDetailsVC = segue.destination as? MovieDetailsViewController

            movieDetailsVC?.movieDetail = self.movieData
            movieDetailsVC?.moviePosterImage = self.moviePosterImage
        }
        else if segue.destination is MovieSearchViewController {
 
        }
    }

}

@available(iOS 13.0, *)
extension MoviesHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 630
        }
        else if indexPath.row == 1 {
            return 330
        }
        else if indexPath.row <= 3 {
            return 180
        }
        
        return 0
    }
}

@available(iOS 13.0, *)
extension MoviesHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let latestMovieCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.identifier, for: indexPath) as! LatestMovieTableViewCell
            
            latestMovieCell.movieList = self.upcomingMoviesList
            
            if latestMovieDetail?.poster_path != nil {
                let url = URL(string: "\(Constants.imageURL)\(Constants.PosterSizes.w500)/\((latestMovieDetail?.poster_path)!)")
                
                latestMovieCell.latestMoviePosterImageView.sd_setImage(with: url)
            }
            
            latestMovieCell.delegate = self
            return latestMovieCell
        }
        else if indexPath.row == 1 {
            let nowPlayingMovieListCell = tableView.dequeueReusableCell(withIdentifier: NowPlayingMoviesTableViewCell.identifier, for: indexPath) as! NowPlayingMoviesTableViewCell
            
            nowPlayingMovieListCell.movieList = self.nowPlayingMoviesList
            nowPlayingMovieListCell.lblMovieGroup.text = Constants.MovieGroup.nowPlaying
            nowPlayingMovieListCell.movieGroup = Constants.MovieGroup.nowPlaying
            
            nowPlayingMovieListCell.delegate = self
            return nowPlayingMovieListCell
            
        }
        else if indexPath.row == 2 {
            let popularMovieListCell = tableView.dequeueReusableCell(withIdentifier: MoviesListTableViewCell.identifier, for: indexPath) as! MoviesListTableViewCell

            popularMovieListCell.movieList = self.popularMoviesList
            popularMovieListCell.lblMovieGroup.text = Constants.MovieGroup.popular
            popularMovieListCell.movieGroup = Constants.MovieGroup.popular
            popularMovieListCell.delegate = self
            return popularMovieListCell
        }
        else if indexPath.row == 3 {
            let topRatedMovieListCell = tableView.dequeueReusableCell(withIdentifier: MoviesListTableViewCell.identifier, for: indexPath) as! MoviesListTableViewCell
            
            topRatedMovieListCell.movieList = self.topRatedMoviesList
            topRatedMovieListCell.lblMovieGroup.text = Constants.MovieGroup.topRated
            topRatedMovieListCell.movieGroup = Constants.MovieGroup.topRated
            topRatedMovieListCell.delegate = self
            
            return topRatedMovieListCell
        }
        
        return UITableViewCell()
    }
}

@available(iOS 13.0, *)
extension MoviesHomeViewController: CollectionCellDelegateProtocol {
    func didClickACell(movieData: MovieInformation, moviePosterImage: UIImage) {
        
        self.movieData = movieData
        self.moviePosterImage = moviePosterImage
        
        performSegue(withIdentifier: "MovieDetailsViewController", sender: self)
    }
    
    func didReachEndOfCollection(movieGroup: String) {
        if movieGroup == Constants.MovieGroup.upcoming {
            if upComingMoviesPage < upcomingMovies!.total_pages {
                getUpcomingMovies(page: upComingMoviesPage + 1)
            }
        }
        else if movieGroup == Constants.MovieGroup.nowPlaying {
            if nowPlayingMoviesPage < nowPlayingMovies!.total_pages {
                getNowPlayingMovies(page: nowPlayingMoviesPage + 1)
            }
        }
        else if movieGroup == Constants.MovieGroup.popular {
            if popularMoviesPage < popularMovies!.total_pages {
                getPopularMovies(page: popularMoviesPage + 1)
            }
        }
        else if movieGroup == Constants.MovieGroup.topRated {
            if topRatedMoviesPage < topRatedMovies!.total_pages {
                getTopRatedMovies(page: topRatedMoviesPage + 1)
            }
        }
    }
}
