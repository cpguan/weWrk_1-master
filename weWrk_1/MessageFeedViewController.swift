
//  Created by luis castillo on 3/22/17.
//  Copyright © 2017 luis castill0. All rights reserved.


import UIKit

class MessageFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back Arrow")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back Arrow")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }


}
