//
//  ComposePostViewController.swift
//  VhsHackcess
//
//  Created by Victor Zhong on 2/19/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class ComposePostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var topicField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var statusLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIButton!
    @IBAction func postButtonTapped(_ sender: UIButton) {
        postPost()
    }
    
    var databaseRef: FIRDatabaseReference!
    var currentUser: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicField.delegate = self
        commentField.delegate = self
        
        //color scheme
        postButton.tintColor = ColorManager.shared.primary
        
        if let communityID = Community.community.communityID {
            databaseRef = FIRDatabase.database().reference().child(communityID).child("posts")
            checkLoggedIn()
        }
        else {
            postButton.isEnabled = false
            statusLabel.text = "Community Not Chosen"
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func checkLoggedIn() {
        if let user = FIRAuth.auth()?.currentUser {
            if let email = user.email {
                currentUser = user
                statusLabel.text = "Posting as \(email)"
                postButton.isEnabled = true
            }
        }
        else {
            showOKAlert(title: "Error", message: "You must be logged in to continue!", dismissCompletion: {
                action in self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func postPost() {
        if let topic = topicField.text, let comment = commentField.text {
            postButton.isEnabled = false
            
            let postRef = databaseRef.childByAutoId()
            let postRefDict: [String : String] = [
                "Author" : (currentUser.email)!,
                "Body" : comment,
                "Title" : topic,
                "UID" : currentUser.uid,
                "PostID" : postRef.key
                //                "commentCount" : 0
            ]
            postRef.setValue(postRefDict) { (error, reference) in
                if error != nil {
                    self.showOKAlert(title: "Error!", message: error?.localizedDescription)
                    self.postButton.isEnabled = true
                }
                else {
                    self.showOKAlert(title: "Message Posted!", message: nil, dismissCompletion: {
                        action in self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == topicField {
            dismissKeyboard()
            return false
        }
        return true
    }
    
    func showOKAlert(title: String, message: String?, dismissCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: dismissCompletion)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: completion)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height / 2
            statusLabelBottom.isActive = false
            statusLabelBottom = statusLabel.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -keyboardHeight - 8.0)
            statusLabelBottom.isActive = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        statusLabelBottom.isActive = false
        statusLabelBottom = statusLabel.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8.0)
        statusLabelBottom.isActive = true
    }
    
    
}
