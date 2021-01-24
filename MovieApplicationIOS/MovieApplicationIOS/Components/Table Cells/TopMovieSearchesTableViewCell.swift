import UIKit

class TopMovieSearchesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgViewMoviePoster: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    
    static let identifier = "TopMovieSearchesTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TopMovieSearchesTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgViewMoviePoster.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
