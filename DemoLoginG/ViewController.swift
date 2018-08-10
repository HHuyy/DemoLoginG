//
//  ViewController.swift
//  DemoLoginG
//
//  Created by Đừng xóa on 8/8/18.
//  Copyright © 2018 Đừng xóa. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var avarImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    var dispatchWorkItem: DispatchWorkItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
//        let googleSignInButton = GIDSignInButton()
//        googleSignInButton.center = view.center
//        view.addSubview(googleSignInButton)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error ?? "google error")
            return
        }
        
        emailLabel.text = user.profile.email
        if user.profile.hasImage == true {
            let imageUrl = user.profile.imageURL(withDimension: 120)
            print(imageUrl!)
            loadViewIfNeeded()
            getImage(from: "\(imageUrl!)", completedHandler: { (image) in
                self.avarImage.image = image
            })
        }
    }
    
    
    @IBAction func ss(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        if GIDSignIn.sharedInstance().currentUser == nil {
            emailLabel.text = "No data"
            avarImage.image = #imageLiteral(resourceName: "NoPhoto")
            view.reloadInputViews()
        }
    }
    
    func getImage(from urlString: String, completedHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {return}
        var image: UIImage?
        dispatchWorkItem = DispatchWorkItem(block: {
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
        })
        DispatchQueue.global().async {
            self.dispatchWorkItem?.perform()
            DispatchQueue.main.async {
                completedHandler(image)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

