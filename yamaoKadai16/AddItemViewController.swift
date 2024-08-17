
import UIKit

class AddItemViewController: UIViewController {

    enum Mode {
        case Add, Edit
    }
    
    var mode = Mode.Add
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if mode == .Edit {
            nameTextField.text = name
        }
    }
    
    
    @IBAction func pressSaveButton(sender: AnyObject) {
                let identifier = (mode == .Add) ? "exitFromAddBySaveSegue" : "exitFromEditBySaveSegue"
                performSegue(withIdentifier: identifier, sender: sender)
    }
    
    @IBAction func pressCancelButton(sender: AnyObject) {
        let identifier = (mode == .Add) ? "exitFromAddByCancelSegue" : "exitFromEditByCancelSegue"
        performSegue(withIdentifier: identifier, sender: sender)
    }
}
