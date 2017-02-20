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
            
            populatePosts()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkChosenCommunity()
        populatePosts()
    }
    
    // MARK: - Functions
    
    func checkChosenCommunity() {
        if communityBoroughCode != Community.community.communityID {
            communityBoroughCode = Community.community.communityID
            if let community = communityBoroughCode {
                databaseRef = FIRDatabase.database().reference().child(community)
                self.title = "\(community) Forums"
            }
            
            populatePosts()
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
