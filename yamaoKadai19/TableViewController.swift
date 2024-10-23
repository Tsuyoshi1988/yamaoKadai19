import UIKit

struct Item {
    var name: String
    var check: Bool
}

class TableViewController: UITableViewController {

    // タイププロパティ
    static let UserDefaultsKeyItems = "Items"
    
    struct Item {
        var name:String
        var check:Bool
        
        // タイププロパティ
        static let KeyName = "Name"
        
        // タイププロパティ
        static let KeyCheck = "Check"
        
        func dictionary() -> NSDictionary {
            return [Item.KeyName:name, Item.KeyCheck:check]
        }
        
        init(dic:NSDictionary) {
            name = (dic[Item.KeyName] as? String) ?? ""
            check = (dic[Item.KeyCheck] as? Bool) ?? false
        }
        
        init(name:String, check:Bool) {
            self.name = name
            self.check = check
        }
    }
    
    var items: [Item] = []

    var editIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.items = [
            Item(name: "りんご", check: false),
            Item(name: "みかん", check: false),
            Item(name: "バナナ", check: true),
            Item(name: "パイナップル", check: true)
        ]
        
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ItemTableViewCell

        let item = self.items[indexPath.row]

        cell.checkImageView.image = nil
        if item.check {
            cell.checkImageView.image = UIImage(named: "check")
        }
        
        cell.nameLabel.text = item.name

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            saveItems()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].check = !self.items[indexPath.row].check
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        saveItems()
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
            editIndexPath = indexPath
            performSegue(withIdentifier: "EditSegue", sender: indexPath)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let add = (segue.destination as? UINavigationController)?.topViewController as? AddItemViewController {
            switch segue.identifier ?? "" {
            case "AddSegue":
                add.mode = .add
                break
            case "EditSegue":
                if let indexPath = sender as? IndexPath {
                    let item = self.items[indexPath.row]
                    //add.mode = .edit(item: item)
                    add.name = item.name
                }
            default:
                break
            }
        }
    }

    @IBAction func exitFromAddByCancel(segue: UIStoryboardSegue) {

    }

    @IBAction func exitFromAddBySave(segue: UIStoryboardSegue) {
        if let add = segue.source as? AddItemViewController {
            let item = Item(name: add.nameTextField.text!, check: false)
            self.items.append(item)
            let indexPath = IndexPath(row: self.items.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
            saveItems()
        }
    }

    @IBAction func exitFromEditByCancel(segue:UIStoryboardSegue) {

    }

    @IBAction func exitFromEditBySave(segue:UIStoryboardSegue) {
        if let add = segue.source as? AddItemViewController {
            if let indexPath = editIndexPath {
                self.items[indexPath.row].name = add.nameTextField.text ?? ""
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
                saveItems()
            }
        }
    }
    
    func loadItems() {
        let ud = UserDefaults.standard
        if let dics = ud.array(forKey: TableViewController.UserDefaultsKeyItems) {
            self.items = []
            for dic in dics {
                if let d = dic as? NSDictionary {
                    let item = Item(dic: d)
                    self.items.append(item)
                }
            }
        }
    }
    
    func saveItems() {
        let dics = NSMutableArray()
        for item in items {
            let dic = item.dictionary()
            dics.add(dic)
        }
        let ud = UserDefaults.standard
        ud.set(dics, forKey: TableViewController.UserDefaultsKeyItems)
        ud.synchronize()
    }
}
