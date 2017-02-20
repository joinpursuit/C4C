//
//  MessageBoardTableViewController.swift
//  VhsHackcess
//
//  Created by Victor Zhong on 2/18/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MessageBoardTableViewController: UITableViewController {
    
    var posts = [Post]()
    var communityBoroughCode: String?
    var databaseRef: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //black nav bar color
        self.navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = ColorManager.shared.primary
        
        if let community = Community.community.communityID {
            communityBoroughCode = community
            databaseRef = FIRDatabase.database().reference().child(community)
            self.title = "\(community) Forums"
        }
        else {
            showOKAlert(title: "Please select a district first!", message: nil, dismissCompletion: {
                action in self.tabBarController?.selectedIndex = 0;
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        posts.removeAll()
        if Community.community.communityID == nil {
            showOKAlert(title: "Please select a district first!", message: nil, dismissCompletion: {
                action in self.tabBarController?.selectedIndex = 0;
            })
        }
        checkChosenCommunity()
        populatePosts()
    }
    
    // MARK: - Functions
    
    func showOKAlert(title: String, message: String?, dismissCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: dismissCompletion)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: completion)
    }
    
    func checkChosenCommunity() {
        if communityBoroughCode != Community.community.communityID {
            communityBoroughCode = Community.community.communityID
            if let community = communityBoroughCode {
                databaseRef = FIRDatabase.database().reference().child(community)
                self.title = "\(community) Forums"
            }
        }
    }
    
    func populatePosts() {
        if let _ = communityBoroughCode {
            posts.removeAll()
            
            databaseRef?.child("posts").observeSingleEvent(of: .value , with: { (snapshot) in
                
                for child in snapshot.children {
                    if let snap = child as? FIRDataSnapshot,
                        let valueDict = snap.value as? [String : Any] {
                        let post = Post(uid: valueDict["UID"] as! String, author: valueDict["Author"] as! String, title: valueDict["Title"] as! String, body: valueDict["Body"] as! String)//, commentCount: valueDict["commentCount"] as! Int)
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.topicHeadline.text = post.title
        cell.postCommentLabel.text = post.body
        cell.infoLabel.text = "By \(post.author)" // - \(post.commentCount) replies"
        
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
