
import UIKit

class TableViewController: UITableViewController {
    
    struct Item {
        var name: String
        var check: Bool
    }

     var items: [Item] = []
    
    var editIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.items = [
            Item(name: "りんご", check: false),
            Item(name: "みかん", check: false),
            Item(name: "バナナ", check: true),
            Item(name: "パイナップル", check: true),
        ]
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
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.items[indexPath.row].check = !self.items[indexPath.row].check
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
            print("accessoryButtonTappedForRowWithIndexPath")
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
                    add.mode = .edit(name: item.name)
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
        }
    }
    
    @IBAction func exitFromEditByCancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func exitFromEditBySave(segue:UIStoryboardSegue) {
        if let add = segue.source as? AddItemViewController {
            if let indexPath = editIndexPath {
                self.items[indexPath.row].name = add.nameTextField.text ?? ""
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
