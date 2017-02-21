//
//  PostViewController.swift
//  VhsHackcess
//
//  Created by Victor Zhong on 2/20/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var replyField: UITextField!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBAction func replyButtonTapped(_ sender: UIButton) {
        postComment()
    }
    
    var postString: String!
    var commmunityID: String!
    var databaseRef: FIRDatabaseReference!
    var commentRef: FIRDatabaseReference!
    var post = Post()
    var comments = [Comment]()
    var currentUser: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        //color scheme
        self.replyButton.tintColor = ColorManager.shared.primary
        
        replyField.delegate = self
        databaseRef = FIRDatabase.database().reference().child(commmunityID).child("posts").child(postString)
        commentRef = FIRDatabase.database().reference().child(commmunityID).child("post_comments").child(postString)
        populatePost()
        populateComments()
        checkLoggedIn()
        
        self.commentTableView.estimatedRowHeight = 150.0
        self.commentTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func populatePost() {
        titleLabel.text = post.title
        idLabel.text = "Submitted by \(post.author)"
        commentView.text = post.body
    }
    
    func checkLoggedIn() {
        if let user = FIRAuth.auth()?.currentUser {
            currentUser = user
            replyButton.isEnabled = true
        }
    }
    
    func populateComments() {
        comments.removeAll()
        
        commentRef?.observeSingleEvent(of: .value , with: { (snapshot) in
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String : Any] {
                    let comment = Comment(uid: valueDict["UID"] as! String,
                                          author: valueDict["Author"] as! String,
                                          text: valueDict["Text"] as! String)
                    self.comments.append(comment)
                }
            }
            
            self.commentTableView.reloadData()
        })
    }
    
    func postComment() {
        if let reply = replyField.text {
            replyButton.isEnabled = false
            
            let replyRef = commentRef.childByAutoId()
            let replyRefDict: [String : String] = [
                "Author" : (currentUser.email)!,
                "Text" : reply,
                "UID" : currentUser.uid
            ]
            replyRef.setValue(replyRefDict) { (error, reference) in
                if error != nil {
                    self.showOKAlert(title: "Error!", message: error?.localizedDescription)
                }
                else {
                    self.showOKAlert(title: "Message Posted!", message: nil, dismissCompletion: {
                        action in self.populateComments()
                    }, completion: {
                        self.replyField.text = ""
                    })
                }
            }
            self.replyButton.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        replyButtonTapped(replyButton)
        return true
    }
    
    func showOKAlert(title: String, message: String?, dismissCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: dismissCompletion)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: completion)
    }
    
    // MARK: - tableView Stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseComment", for: indexPath) as! CommentTableViewCell
        cell.commentLabel?.text = comments[indexPath.row].text
        cell.infoLabel?.text = "Submitted by \(comments[indexPath.row].author)"
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
