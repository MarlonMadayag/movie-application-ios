import UIKit

class MoviesListTableViewCell: UITableViewCell {
    
    static let identifier = "MoviesListTableViewCell"
    
    var delegate: CollectionCellDelegateProtocol?
    
    @IBOutlet weak var lblMovieGroup: UILabel!
    @IBOutlet weak var cvMovieGroupCollectionView: UICollectionView!
    
    var movieGroup: String?
    
    var movieList: [MovieInformation]? {
        didSet {
            DispatchQueue.main.async { self.cvMovieGroupCollectionView.reloadData() }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MoviesListTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cvMovieGroupCollectionView.register(MovieGroupListCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieGroupListCollectionViewCell.identifier)
        cvMovieGroupCollectionView.delegate = self
        cvMovieGroupCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MoviesListTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieGroupListCollectionViewCell
        let movieData = (movieList?[indexPath[1]])!
        
        self.delegate?.didClickACell(movieData: movieData, moviePosterImage: cell.movieImagePosterImageView.image!)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if movieList != nil && indexPath.row == (movieList?.count)! - 1 {
            self.delegate?.didReachEndOfCollection(movieGroup: self.movieGroup!)
        }
    }
}

extension MoviesListTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieList != nil {
            return (movieList?.count)!
        }
        else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieGroupListCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieGroupListCollectionViewCell.identifier, for: indexPath) as! MovieGroupListCollectionViewCell

        if movieList != nil {
            let result = movieList![indexPath.row]
            let url = URL(string: "\(Constants.imageURL)\(Constants.PosterSizes.w154)/\(result.poster_path!)")
            
            movieGroupListCell.movieImagePosterImageView.sd_setImage(with: url)
        }
        
        return movieGroupListCell
    }
}

extension MoviesListTableViewCell: UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 200, height: 450)
    //    }
}
