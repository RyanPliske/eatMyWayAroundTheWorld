import UIKit

class ViewController: UIViewController {
    
    let dataModel = RestaurantModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myListViewController = segue.destination as? MyListViewController {
            myListViewController.dataModel = dataModel
        } else if let searchViewController = segue.destination as? SearchViewController {
            searchViewController.dataModel = dataModel
        }
    }
}
