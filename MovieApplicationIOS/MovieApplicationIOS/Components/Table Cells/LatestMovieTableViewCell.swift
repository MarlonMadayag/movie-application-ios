import UIKit

class LatestMovieTableViewCell: UITableViewCell {
    
    static let identifier = "LatestMovieTableViewCell"
    
    var delegate: CollectionCellDelegateProtocol?
    
    @IBOutlet weak var latestMoviePosterImageView: UIImageView!
    @IBOutlet weak var moviesListCollectionView: UICollectionView!
    
    var movieList: [MovieInformation]? {
        didSet {
            DispatchQueue.main.async { self.moviesListCollectionView.reloadData() }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "LatestMovieTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        moviesListCollectionView.register(MovieGroupListCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieGroupListCollectionViewCell.identifier)
        moviesListCollectionView.delegate = self
        moviesListCollectionView.dataSource = self
        DispatchQueue.main.async { self.moviesListCollectionView.reloadData() }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension LatestMovieTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MovieGroupListCollectionViewCell
        let movieData = (movieList?[indexPath[1]])!

        self.delegate?.didClickACell(movieData: movieData, moviePosterImage: cell.movieImagePosterImageView.image!)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if movieList != nil && indexPath.row == (movieList?.count)! - 1 {

            self.delegate?.didReachEndOfCollection(movieGroup: Constants.MovieGroup.upcoming)
        }
    }
}

extension LatestMovieTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieList != nil {
            return (movieList?.count)!
        }
        else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieImageRoundCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieGroupListCollectionViewCell.identifier, for: indexPath) as! MovieGroupListCollectionViewCell

        if movieList != nil {
            let result = movieList![indexPath.row]
            let posterPath = result.poster_path
            
            if posterPath != nil {
                let url = URL(string: "\(Constants.imageURL)\(Constants.PosterSizes.w154)/\(posterPath!)")

                movieImageRoundCell.movieImagePosterImageView.sd_setImage(with: url)
            }
            movieImageRoundCell.movieImagePosterImageView.layer.cornerRadius = 60
        }

        return movieImageRoundCell
    }
}

extension LatestMovieTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
