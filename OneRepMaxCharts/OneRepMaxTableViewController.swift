//
//  OneRepMaxTableViewController.swift
//  OneRepMaxCharts
//
//  Created by George Hsin on 10/23/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class OneRepMaxTableViewController: UITableViewController {
    
    var oneRepMaxData = [String:[(String, Int)]]()
    var exercises = [String]()
    var exercise: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .background).async {
            WorkoutData.sharedInstance.getWorkoutData { (returnedData, exercises) in
                self.oneRepMaxData = returnedData
                self.exercises = exercises
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return oneRepMaxData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneRepMaxCell
        let exercise = exercises[indexPath.row]
        cell.oneRepMaxLabel.text = String(describing: oneRepMaxData[exercise]![0].1)
        cell.exerciseNameLabel.text = exercise
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exercise = exercises[indexPath.row]
        performSegue(withIdentifier: "graphView", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "graphView" {
            let graphViewController = segue.destination as? GraphOneRepMaxViewController
            graphViewController?.exercise = exercise
        }

    }

}
