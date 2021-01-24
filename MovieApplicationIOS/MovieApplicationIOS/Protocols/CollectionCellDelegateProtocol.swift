import Foundation
import UIKit

protocol CollectionCellDelegateProtocol {
    func didClickACell(movieData: MovieInformation, moviePosterImage: UIImage)
    func didReachEndOfCollection(movieGroup: String)
}
