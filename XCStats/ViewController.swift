//
//  ViewController.swift
//  XCStats
//
//  Created by Seshu Adunuthula on 1/17/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var athletePicker: UIPickerView!
    @IBOutlet weak var eventsTableView: UITableView!
    var xcModel = XCStatsModel()
    var pickerData:[String] = []
    var athlete:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventsTableView.dataSource = self
        self.athletePicker.dataSource = self
        self.athletePicker.delegate = self
        
        eventsTableView.reloadData()
        pickerData = xcModel.getAllAthletes()
        athlete = pickerData[0]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xcModel.getAthleteRecords(athlete: athlete).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let records:[XCStatRecord] = xcModel.getAthleteRecords(athlete: athlete)
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! EventTableViewCell
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.string(from:records[indexPath.row].eventDate)
        cell.dateLabel!.text = date
        
        let rank = "Rank " + String(records[indexPath.row].placement)
        cell.rankLabel.text = rank
        
        let runners = "Runners " + String(records[indexPath.row].totalRunners)
        cell.numRunnersLabel!.text = runners
        
        cell.eventLabel!.text = records[indexPath.row].eventName
        cell.divisionLabel!.text = records[indexPath.row].division.rawValue
        return cell
    }
    
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        athlete = pickerData[row]
        eventsTableView?.reloadData()
    }
}

