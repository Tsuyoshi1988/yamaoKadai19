
import UIKit

class TableViewController: UITableViewController {
    
    let keyName = "Name"
    let keyCheck = "Check"
    
    var items: [[String: Any]] = []
    
    var editIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = [
            [keyName: "りんご", keyCheck: false],
            [keyName: "みかん", keyCheck: false],
            [keyName: "バナナ", keyCheck: true],
            [keyName: "パイナップル", keyCheck: false],
        ]
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ItemTableViewCell
        
        let item = self.items[indexPath.row]
        
        cell.checkImageView.image = nil
        if item[keyCheck] as? Bool == true {
            cell.checkImageView.image = UIImage(named: "check")
        }
        
        cell.nameLabel.text = (item[keyName] as? String) ?? ""
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let check = self.items[indexPath.row][keyCheck] as? Bool {
            self.items[indexPath.row][keyCheck] = !check
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
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
                    let name = (item[keyName] as? String) ?? ""
                    add.mode = .edit(name: name)
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
            let item:[String: Any] = [keyName: add.nameTextField.text as Any, keyCheck: false]
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
                self.items[indexPath.row][keyName] = add.nameTextField.text
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
