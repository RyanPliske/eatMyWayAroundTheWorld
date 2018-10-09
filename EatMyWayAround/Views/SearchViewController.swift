import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var dataModel: RestaurantModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel?.dataAvailableDelegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.searchResults.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell") else { return UITableViewCell() }
        
        cell.textLabel?.text = "\(dataModel?.searchResults[indexPath.row].name ?? "Data Unavailable" )"
        
        cell.detailTextLabel?.text = """
        \(dataModel?.searchResults[indexPath.row].cuisines ?? "Data Unavailable")
        User Rating: \(dataModel?.searchResults[indexPath.row].user_rating.aggregate_rating ?? "Data Unavailable") from \(dataModel?.searchResults[indexPath.row].user_rating.votes ?? "Data Unavailable") votes
        Average Cost for 2: \(dataModel?.searchResults[indexPath.row].average_cost_for_two ?? 0)
        \(dataModel?.searchResults[indexPath.row].location.address ?? "Data Unavailable")
        """
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Add \(dataModel?.searchResults[indexPath.row].name ?? "Data Unavailable" ) to your list?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            guard let restaurant = self.dataModel?.searchResults[indexPath.row] else { return }
            self.dataModel?.saveToList(restaurant: restaurant)
        }))
        
        self.present(alert, animated: true)
    }
}

extension SearchViewController: DataAvailableDelegate {
    func dataAvailable() {
        searchResultsTableView.reloadData()
    }
}
