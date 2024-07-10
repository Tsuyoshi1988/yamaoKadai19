
import UIKit

class TableViewController: UITableViewController {

    let keyName = "Name"
    let keyCheck = "Check"
    
    var items: [Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.items = [
            [keyName:"りんご", keyCheck:false],
            [keyName:"みかん", keyCheck:false],
            [keyName:"バナナ", keyCheck:true],
            [keyName:"パイナップル", keyCheck:false],
        ]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ItemTableViewCell

        // Configure the cell...
        let item = self.items[indexPath.row]
        
        cell.checkImageView.image = nil
        if item[keyCheck] as? Bool == true {
            cell.checkImageView.image = UIImage(named: "check")
        }
        cell.nameLabel.text = (item[keyName] as? String) ?? ""
        
        return cell
    }
    
    @IBAction func exitFromAddByCancel(segue:UIStoryboardSegue) {
        
    }

    @IBAction func exitFromAddBySave(segue:UIStoryboardSegue) {
        if let add = segue.source as? AddItemViewController {
            let item:Dictionary<String,Any> = [keyName:add.nameTextField.text, keyCheck:false]
            self.items.append(item)
            self.tableView.reloadData()
        }
    }
}
