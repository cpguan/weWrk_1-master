

import UIKit
import SwiftKeychainWrapper
import Firebase

class feedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
}

    @IBAction func logoutTapped(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "login", sender: nil)
    }
  
}
