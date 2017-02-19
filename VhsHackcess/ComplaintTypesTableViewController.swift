//
//  ComplaintTypesTableViewController.swift
//  VhsHackcess
//
//  Created by Sabrina Ip on 2/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class ComplaintTypesTableViewController: UITableViewController {
    //MARK: - Outlets
    
    //MARK: - Properties
    var communityBoard: String = "" {
        didSet {
            self.openDataEndpoint = "https://data.cityofnewyork.us/resource/fhrw-4uyv.json?$where=created_date between '2017-01-19' and '2017-02-19'&community_board=\(self.communityBoard)&$limit=50000".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
    }
    var complaintTypes: [String: Int] = [:]
    var tuples: [(String, Int)] = []
    var openDataEndpoint: String = ""
    let cellIdentifier: String = "complaintTypeCell"
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIRequestManager.manager.getData(endPoint: self.openDataEndpoint) { (data: Data?) in
            
            if let cbRequests = ServiceRequest.getServiceRequests(data: data!) {
                
                for request in cbRequests {
                    if let numberOfOccurrences = self.complaintTypes[request.complaintType] {
                        self.complaintTypes[request.complaintType] = numberOfOccurrences + 1
                    }
                    else {
                        self.complaintTypes[request.complaintType] = 1
                    }
                }
                self.setUpTableViewArrays()
                
                print("COMPLAINTS: \(self.complaintTypes)")
                
                print(self.openDataEndpoint)
            }
        }
    }
    
    func setUpTableViewArrays(){
        for (key, value) in self.complaintTypes {
            self.tuples.append((key, value))
        }
        print("TUPLES: \(self.tuples)")
        self.tableView.reloadData()
    }
    
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.complaintTypes.keys.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        let complaint = self.tuples[indexPath.row]
        
        cell.textLabel?.text = "\(complaint.0) (\(complaint.1))"
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - Actions
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
    }
    
}
