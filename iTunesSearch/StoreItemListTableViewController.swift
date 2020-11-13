
import UIKit

class StoreItemListTableViewController: UITableViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
    // add item controller property
    let storeItemController = StoreItemController()
    var items = [StoreItem]()
    let queryOptions = ["movie", "music", "software", "ebook"]
}

extension StoreItemListTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension StoreItemListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
}

extension StoreItemListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StoreItemListTableViewController {
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        fetchMatchingItems()
    }
}

extension StoreItemListTableViewController {
    func fetchMatchingItems() {
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            let query: [String: String] = [
                "term": "eminem",
                "media": "music",
                "limit": "200",
                "lang": "en_us"
            ]
            storeItemController.fetchItems(matching: query) {storeItem in
                if let storeItem = storeItem {
                    DispatchQueue.main.async {
                        self.items = storeItem
                        self.tableView.reloadData()
                    }
                } else {
                    print("error")
                }
            }
            // use the item controller to fetch items
            // if successful, use the main queue to set self.items and reload the table view
            // otherwise, print an error to the console
        }
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        // set label to the item's name
        // set detail label to the item's subtitle
        // reset the image view to the gray image
        
        // initialize a network task to fetch the item's artwork
        // if successful, use the main queue capture the cell, to initialize a UIImage, and set the cell's image view's image to the
        // resume the task
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}
