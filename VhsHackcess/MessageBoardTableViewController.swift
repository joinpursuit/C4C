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
    var communityName: String?
    var databaseRef: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //black nav bar color
        self.navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = ColorManager.shared.primary
        
        if let community = Community.community.communityID {
            checkChosenCommunity()
        }
        else {
            goHome()
        }
        
        self.tableView.estimatedRowHeight = 150.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.allowsSelection = false
        
        if Community.community.communityID == nil {
            goHome()
        }
        else {
            checkChosenCommunity()
            checkCommunityPosting(communityBoroughCode!)
            populatePosts()
        }
    }
    
    // MARK: - Functions
    
    func checkCommunityPosting(_ community: String) {
        let root = FIRDatabase.database().reference().child(community).child("posts")
        root.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChild("main_post") {
                self.generateFirstPost(community: community)
            }
        })
    }
    
    func generateFirstPost(community: String) {
        
        if let complaints = Community.community.majorComplaints {
            if let database = databaseRef {
                let postRef = database.child("posts").child("main_post")
                let postRefDict: [String : String] = [
                    "Author" : "C4C Admin",
                    "Body" : "\(communityName!) is facing \(complaints[0]), \(complaints[1]), and \(complaints[2]) this month",
                    "Title" : "Major Concerns For this Month",
                    "UID" : "C4C ADMIN",
                    "PostID" : postRef.key
                ]
                postRef.setValue(postRefDict) { (error, reference) in
                    if error == nil {
                        print("Setting first post")
                        self.populatePosts()
                    }
                }
            }
        }
    }
    
    func goHome() {
        showOKAlert(title: "Please select a district first!", message: nil, dismissCompletion: {
            action in self.tabBarController?.selectedIndex = 0;
        })
    }
    
    func showOKAlert(title: String, message: String?, dismissCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: dismissCompletion)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: completion)
    }
    
    func checkChosenCommunity() {
        if communityBoroughCode != Community.community.communityID {
            communityBoroughCode = Community.community.communityID
            communityName = Community.community.communityName
            if let community = communityBoroughCode {
                databaseRef = FIRDatabase.database().reference().child(community)
                self.title = "\(communityName!) Forums"
            }
        }
    }
    
    func populatePosts() {
        if let _ = communityBoroughCode {
            posts = []
            
            databaseRef?.child("posts").observeSingleEvent(of: .value , with: { (snapshot) in
                
                for child in snapshot.children {
                    if let snap = child as? FIRDataSnapshot,
                        let valueDict = snap.value as? [String : Any] {
                        let post = Post(uid: valueDict["UID"] as! String,
                                        author: valueDict["Author"] as! String,
                                        title: valueDict["Title"] as! String,
                                        body: valueDict["Body"] as! String,
                                        postID: valueDict["PostID"] as! String)//, commentCount: valueDict["commentCount"] as! Int)
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
                self.tableView.allowsSelection = true
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
        cell.user = post.author
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cellTapped = sender as? PostTableViewCell {
            if segue.identifier == "readSegue" {
                if let postView = segue.destination as? PostViewController {
                    let cellIndexPath = self.tableView.indexPath(for: cellTapped)!
                    
                    postView.post = posts[cellIndexPath.row]
                    postView.postString = posts[cellIndexPath.row].postID
                    postView.commmunityID = communityBoroughCode
                }
            }
        }
    }
}
