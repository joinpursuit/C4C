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
        
        if let community = Community.community.communityName {
            communityBoroughCode = community
            databaseRef = FIRDatabase.database().reference().child(community)
            self.title = "\(community) Forums"
            
            populatePosts()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkChosenCommunity()
    }
    
    // MARK: - Functions
    
    func checkChosenCommunity() {
        if communityBoroughCode != Community.community.communityName {
            communityBoroughCode = Community.community.communityName
            if let community = communityBoroughCode {
                databaseRef = FIRDatabase.database().reference().child(community)
                self.title = "\(community) Forums"
            }
            
            populatePosts()
        }
    }
    
    func populatePosts() {
        if let _ = communityBoroughCode {
            databaseRef?.observeSingleEvent(of: .value , with: { (snapshot) in
                
                for child in snapshot.children {
                    if let snap = child as? FIRDataSnapshot,
                        let valueDict = snap.value as? [String : Any] {
                        let post = Post(uid: valueDict["uid"] as! String, author: valueDict["author"] as! String, title: valueDict["title"] as! String, body: valueDict["body"] as! String, commentCount: valueDict["commentCount"] as! Int)
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
        cell.infoLabel.text = "By \(post.author) - \(post.commentCount) replies"
        
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
