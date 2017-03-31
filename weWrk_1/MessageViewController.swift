//  Copyright © 2017 luis castill0. All rights reserved.


import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseDatabase

class MessageViewController: JSQMessagesViewController{
    var messages = [JSQMessage]()
    var messageRef = FIRDatabase.database().reference().child("messages")
    
    var user: Users? {
        didSet {
            navigationItem.title = user?.displayName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = "t"
        self.senderDisplayName = "luis"
        
        observeMessages()
        // Do any additional setuo after loading the view 
        let rootRef = FIRDatabase.database().reference()
        let messageRef = rootRef.child("messages")  // This is how you create an object in firebase 
        
        messageRef.observe(FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in 
        
            if let dict = snapshot.value as? NSDictionary {
                print(dict)
            }
        }
    }
    
    func observeMessages() {
    
        messageRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                //let MediaType = dict["MediaType"] as! String
                let senderId = dict["senderId"] as! String
                let senderName = dict["senderName"] as! String
                let text = dict["text"] as! String
                self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                self.collectionView.reloadData()
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
       let newMessage = messageRef.childByAutoId()
       let messageData = ["text": text, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "TEXT"]
        newMessage.setValue(messageData)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated:true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(red:0.46, green:0.81, blue:1.00, alpha:1.0))
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
}


extension MessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // get Image 
        
        let picture = info[UIImagePickerControllerOriginalImage] as? UIImage
        let photo = JSQPhotoMediaItem(image: picture!)
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }


}
