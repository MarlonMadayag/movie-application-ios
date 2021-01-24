import UIKit
import PromiseKit

@available(iOS 13.0, *)
class MovieDetailsViewController: UIViewController {
    
    let moviesAPICalls = MoviesApiCalls()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgViewMoviePoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblAdultRating: UILabel!
    @IBOutlet weak var lblRuntime: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblCastMembers: UILabel!
    @IBOutlet weak var cvRecommendedSimilarMovie: UICollectionView!
    
    @IBAction func btnHome(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToMoviesHomeViewController", sender: self)
    }
    @IBAction func btnSearch(_ sender: UIButton) {
    }
    var movieCompleteDetail: MovieDetail? {
        didSet {
            self.lblYear.text = movieCompleteDetail?.release_date
            
            let runtime = movieCompleteDetail?.runtime
            
            if runtime != nil {
                self.lblRuntime.text = "\(Int(runtime!/60))h\(runtime!%60)m"
            }
            if movieCompleteDetail?.overview != nil {
                self.lblOverview.text = movieCompleteDetail?.overview
            }
        }
    }
    var movieDetail: MovieInformation?
    var moviePosterImage: UIImage?
    var moviesRecommended: MovieList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let viewWidth = view.frame.size.width
        let spacing = (viewWidth - (100 * 3)) / 4
        layout.sectionInset = UIEdgeInsets(top: 5, left: spacing, bottom: 5, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.cvRecommendedSimilarMovie.collectionViewLayout = layout

        // Do any additional setup after loading the view.
        lblTitle.text = movieDetail?.title
        let frame = CGRect(x: 0, y: 0, width: 300, height: 600)
        imgViewMoviePoster.frame = frame
        imgViewMoviePoster.image = moviePosterImage
        
        cvRecommendedSimilarMovie.register(MovieGroupListCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieGroupListCollectionViewCell.identifier)
        cvRecommendedSimilarMovie.delegate = self
        cvRecommendedSimilarMovie.dataSource = self
        
        getMovieDetail(movieId: movieDetail!.id)
        getMovieCredits(movieId: movieDetail!.id)
        getRecommendationMovies(movieId: movieDetail!.id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MovieDetailsViewController {

        }
        else if segue.destination is MovieSearchViewController {

        }
    }
    
    func getMovieCredits(movieId: Int) {
        firstly {
            moviesAPICalls.getMovieCredits(movieId: movieId)
        }
        .ensure {
            
        }
        .done { movieCredits in
            let castCount = movieCredits.cast.count
            
            if castCount > 3 {
                self.lblCastMembers.text = "\(movieCredits.cast[0].name), \(movieCredits.cast[1].name), \(movieCredits.cast[2].name)"
            }
            else {
                for cast in movieCredits.cast {
                    self.lblCastMembers.text = self.lblCastMembers.text ?? "" + cast.name
                }
            }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getMovieDetail(movieId: Int) {
        self.lblOverview.text = ""
        self.lblCastMembers.text = ""
        self.lblYear.text = ""
        self.lblRuntime.text = ""
        firstly {
            moviesAPICalls.getMovieDetailsPromise(movieId: movieId)
        }
        .ensure {
        }
        .done { movieCompleteDetail in
            self.movieCompleteDetail = movieCompleteDetail
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getRecommendationMovies(movieId: Int) {
        firstly {
            moviesAPICalls.getRecommendationBaseOnMovie(movieId: movieId)
        }
        .ensure {
            
        }
        .done { recommendedMovies in
            self.moviesRecommended = recommendedMovies
            DispatchQueue.main.async {
                self.cvRecommendedSimilarMovie.reloadData()
            }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
}

@available(iOS 13.0, *)
extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieGroupListCollectionViewCell
        let index = (indexPath[0] * 3) + indexPath[1]

        if index < (moviesRecommended?.results.count)! {
            self.movieDetail = self.moviesRecommended?.results[index]
            self.lblTitle.text = self.movieDetail?.title
            self.imgViewMoviePoster.image = cell.movieImagePosterImageView.image
            getMovieDetail(movieId: self.movieDetail!.id)
            getMovieCredits(movieId: self.movieDetail!.id)
            getRecommendationMovies(movieId: self.movieDetail!.id)
            scrollView.setContentOffset(.zero, animated: true)
        }
    }
}

@available(iOS 13.0, *)
extension MovieDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieGroupListCollectionViewCell.identifier, for: indexPath) as! MovieGroupListCollectionViewCell
        let index = (indexPath[0] * 3) + indexPath[1]
        
        if self.moviesRecommended?.results != nil && (self.moviesRecommended?.results.count)! > index {
            
            let result = self.moviesRecommended!.results[index]
            let posterPath = result.poster_path
            
            if posterPath != nil {
                let url = URL(string: "\(Constants.imageURL)\(Constants.PosterSizes.w154)/\(posterPath!)")

                cell.movieImagePosterImageView.sd_setImage(with: url)
            }

        }
        
        return cell
    }
}

@available(iOS 13.0, *)
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 150)
    }
}
