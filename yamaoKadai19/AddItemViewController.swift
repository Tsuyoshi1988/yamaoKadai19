import UIKit

class AddItemViewController: UIViewController {

    enum Mode {
        case add, edit(item: Item)
    }

    var mode = Mode.add

    @IBOutlet weak var nameTextField: UITextField!

    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        switch mode {
        case .add:
            break
        case .edit(item: let item):
            
            nameTextField.text = item.name
        }
    }

    @IBAction func pressSaveButton(sender: AnyObject) {
                
        let identifier: String

        switch mode {
        case .add:
            identifier = "exitFromAddBySaveSegue"
        case .edit:
            identifier = "exitFromEditBySaveSegue"
        }

        performSegue(withIdentifier: identifier, sender: sender)
    }

    @IBAction func pressCancelButton(sender: AnyObject) {

        let identifier: String

        switch mode {
        case .add:
            identifier = "exitFromAddByCancelSegue"
        case .edit:
            identifier = "exitFromEditByCancelSegue"
        }

        performSegue(withIdentifier: identifier, sender: sender)
    }
}
