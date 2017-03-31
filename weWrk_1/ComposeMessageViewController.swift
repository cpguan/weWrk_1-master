
import UIKit
import Foundation
import Firebase


// View controller that lets you compose messages to users in the database 

class ComposeMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   var user = [Users]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        fetchUser()
    }

    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = Users()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                self.user.append(user)
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            }
        })
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let user = self.user[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ComposeMessageTableViewCell
        
        cell?.userName.text = user.displayName
        cell?.userEmail.text = user.email
        
        if let profileImageUrl = user.profileURL {
           cell?.profileImage.loadImageUsingCacheUrlString(urlString: profileImageUrl)
        }
        
        return cell!
    }
    
    var messagesController: MessageViewController?
    
    func showChatController(user: Users) {
        let messageController = MessageViewController()
        messageController.user = user
        navigationController?.show(messageController, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        let user = self.user[indexPath.row]
        self.showChatController(user: user)
    }
}
