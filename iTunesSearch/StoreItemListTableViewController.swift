
import UIKit

class StoreItemListTableViewController: UITableViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
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
                "term": "\(searchTerm)",
                "media": "\(mediaType)",
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
        }
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.artist
        
        let url = item.artworkUrl
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, reponse, error) in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = image
            }
        })
        task.resume()
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}
