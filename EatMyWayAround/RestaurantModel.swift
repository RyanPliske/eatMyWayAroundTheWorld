import Foundation

protocol DataAvailableDelegate: class {
    func dataAvailable()
}

protocol RestaurantModelDelegate: class {
    func dataSaved()
    func errorSaving()
    func reloadData()
}

final class RestaurantModel {
    
    private let currentUser = "currentUser"
    var persistedList: [Restaurant?] = []
    
    private let location = Location()
    private let persistence = Persistence()
    private let settingsDefaults = SettingDefaults()
    
    var searchResults = [Restaurant]()
    
    var lastRequestToSave: DispatchWorkItem?
    
    weak var restaurantModelDelegate: RestaurantModelDelegate?
    
    private let dataFetcher: RestaurantDataFetcher
    weak var dataAvailableDelegate: DataAvailableDelegate?
    
    init() {
        dataFetcher = RestaurantDataFetcher()
        dataFetcher.fetchRestaurant(location: location) { [weak self] (restaurants) in
            for restaurant in restaurants {
                self?.searchResults.append(restaurant)
            }
            
            self?.dataAvailableDelegate?.dataAvailable()
        }
    }
    
    func getPersistedList(user: String) -> [Restaurant?] {
        guard let listJSON = persistence.readUserList(for: currentUser) else {
            return []
        }
        
        guard let arrayOfRestaurants = listJSON["restaurantList"] as? [JSON] else {
            return []
        }
        
        let restaurants = arrayOfRestaurants.flatMap { (json) -> Restaurant? in
            guard let restaurantJSON = json["restaurantList"] as? JSON else {
                return nil
            }
            
            do {
                let restaurantData = try JSONSerialization.data(withJSONObject: restaurantJSON, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                let restaurant = try JSONDecoder().decode(Restaurant.self, from: restaurantData)
                return restaurant
            } catch let error as NSError {
                print(error.debugDescription)
                return nil
            }
        }
        return restaurants
    }
    
    func setPersistedList(list: [Restaurant?]) {
        persistedList = getPersistedList(user: currentUser)
    }
    
    func saveToList(restaurant: Restaurant) {
        lastRequestToSave?.cancel()
        
        let saveChangesWorkItem = DispatchWorkItem { [weak self] in
            do {
                var currentList = self?.getPersistedList(user: (self?.currentUser)!) ?? []
                currentList.append(restaurant)
                
                let appDataDictionary = ["restaurantList": currentList]
                
                let restaurantData = try JSONEncoder().encode(appDataDictionary)
                
                guard let currentUser = self?.currentUser else { return }
                
                let result = self?.persistence.writeToUserList(appData: restaurantData, user: currentUser) ?? false
                result ? self?.restaurantModelDelegate?.dataSaved() : self?.restaurantModelDelegate?.errorSaving()
                
                self?.setPersistedList(list: currentList)
                
            } catch let error as NSError {
                print (error.debugDescription)
            }
        }
        
        lastRequestToSave = saveChangesWorkItem
        let _ = saveChangesWorkItem.wait(timeout: .now() + 2)
        
        saveChangesWorkItem.perform()
    }
}
