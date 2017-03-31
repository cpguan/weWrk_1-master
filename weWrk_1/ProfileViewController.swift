
import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.setRadius()
       // Access inofromation from Firebase Storage
       //username.text = user.name
        
        if let user = DataService.dataService.currentUser {
            if user.photoURL != nil {
                if let data = NSData(contentsOf: user.photoURL!) {
                   self.profileImage.image = UIImage.init(data: data as Data) 
                }
            }
        }
    }
}



