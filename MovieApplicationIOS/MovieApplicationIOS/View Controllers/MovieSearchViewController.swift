import UIKit
import PromiseKit
import Combine

@available(iOS 13.0, *)
class MovieSearchViewController: UIViewController {

    let moviesAPICalls = MoviesApiCalls()
    let searchController = UISearchController(searchResultsController: nil)
    
    
//    var cancellable = [AnyCancellable]()
    var topRatedMovies: MovieList?
    var topRatedMoviesList = [MovieInformation]()
    var topRatedMoviesPage: Int = 1
    
    var isFetchingData: Bool = false
    var isSearching: Bool = false
    var topRatedSearchList = [MovieInformation]()
    
    @IBOutlet weak var tvTopMovieSearches: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController

        // Do any additional setup after loading the view.
        tvTopMovieSearches.register(TopMovieSearchesTableViewCell.nib(), forCellReuseIdentifier: TopMovieSearchesTableViewCell.identifier)
        tvTopMovieSearches.delegate = self
        tvTopMovieSearches.dataSource = self
        
        searchController.searchBar.delegate = self
//        applyCombineSearch()
        getTopRatedMovies(page: topRatedMoviesPage)
    }
    
////    Initialise the publisher and subscriber for search
//    func applyCombineSearch() {
//      let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
//      publisher
//        .map {
//          ($0.object as! UISearchTextField).text
//      }
//      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//      .sink(receiveValue: { (value) in
//        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
//          //Use search text and perform the query
//            self!.filterTopRatedMovies(searchText: value!)
//          DispatchQueue.main.async {
//            //Update UI
//          }
//        }
//      })
////      .store(in: &cancellable)
//    }

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
            self.isFetchingData = false
            DispatchQueue.main.async {
                self.tvTopMovieSearches.tableFooterView = nil
                self.tvTopMovieSearches.reloadData()
            }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func filterTopRatedMovies(searchText: String ) {
        isSearching = true
        self.topRatedSearchList = self.topRatedMoviesList.filter({ (movieData) -> Bool in
            return movieData.title.lowercased().contains(searchText.lowercased())
        })
        DispatchQueue.main.async { self.tvTopMovieSearches.reloadData() }
    }
    
    func createTableViewFooterSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        let spinner = UIActivityIndicatorView()
        
        spinner.startAnimating()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        
        return footerView
    }

}

@available(iOS 13.0, *)
extension MovieSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tvTopMovieSearches.contentSize.height - 10 - scrollView.frame.size.height) {
            if !isFetchingData && (topRatedMoviesPage < topRatedMovies!.total_pages)  {
                self.tvTopMovieSearches.tableFooterView = createTableViewFooterSpinner()
                getTopRatedMovies(page: topRatedMoviesPage + 1)
            }
            isFetchingData = true
        }
    }

}

@available(iOS 13.0, *)
extension MovieSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching && !(searchController.searchBar.text == "") {
            return topRatedSearchList.count
        }
        return topRatedMoviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopMovieSearchesTableViewCell.identifier, for: indexPath) as! TopMovieSearchesTableViewCell

        var result: MovieInformation?
        
        if isSearching && !(searchController.searchBar.text == "") {
            result = self.topRatedSearchList[indexPath.row]
        }
        else {
            result = self.topRatedMoviesList[indexPath.row]
        }
        
        cell.lblMovieTitle.text = result?.title

        if result?.poster_path != nil {
            let url = URL(string: "\(Constants.imageURL)\(Constants.PosterSizes.w154)/\((result?.poster_path)!)")
            
            cell.imgViewMoviePoster.sd_setImage(with: url)
        }
        return cell
    }
    
}

@available(iOS 13.0, *)
extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            isSearching = false
            DispatchQueue.main.async { self.tvTopMovieSearches.reloadData() }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        DispatchQueue.main.async { self.tvTopMovieSearches.reloadData() }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.filterTopRatedMovies(searchText: searchBar.text!)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterTopRatedMovies(searchText: searchBar.text!)
    }

}
