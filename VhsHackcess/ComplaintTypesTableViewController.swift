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
        
        self.title = self.communityBoard
        
        //populate complaintTypes dictionary
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
                DispatchQueue.main.async {
                    self.setUpTableViewArrays()
                }
                
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
        
        //sorted results
        let complaint = self.tuples.sorted { $0.1 > $1.1 }[indexPath.row]
        
        cell.textLabel?.text = "\(complaint.0) (\(complaint.1))"
        return cell
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tappedCell = sender as? UITableViewCell, // change if using custom class
            let dvc = segue.destination as? MapViewController,
            let cellIndexPath = self.tableView.indexPath(for: tappedCell)
            else { return }
        let selectedComplaint = self.tuples.sorted { $0.1 > $1.1 }[cellIndexPath.row]
        
        if let endpoint = "https://data.cityofnewyork.us/resource/fhrw-4uyv.json?$where=created_date between '2017-01-19' and '2017-02-19'&community_board=\(self.communityBoard)&complaint_type=\(selectedComplaint.0)&$limit=50000".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        {
            dvc.endpoint = endpoint
            dvc.complaintType = selectedComplaint.0
        }
        
    }
    
    //MARK: - Actions
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
    }
    
}
