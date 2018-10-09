import UIKit

class MyListViewController: UIViewController {

    @IBOutlet weak var myListTableView: UITableView!
    
    var dataModel: RestaurantModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel?.dataAvailableDelegate = self
        myListTableView.delegate = self
        myListTableView.dataSource = self
    }
}

extension MyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.persistedList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell"), let restaurant = dataModel?.persistedList[indexPath.row] else { return UITableViewCell() }
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = """
        \(restaurant.cuisines)
        User Rating: \(restaurant.user_rating.aggregate_rating) from \(restaurant.user_rating.votes) votes
        Average Cost for 2: \(restaurant.average_cost_for_two)
        \(restaurant.location.address)
        """
        return cell
    }
}

extension MyListViewController: UITableViewDelegate {
    
}

extension MyListViewController: DataAvailableDelegate {
    func dataAvailable() {
        myListTableView.reloadData()
    }
}
