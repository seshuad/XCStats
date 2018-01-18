//
//  AppDelegate.swift
//  DLoader
//
//  Created by Seshu Adunuthula on 1/17/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import Cocoa
import CloudKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("Loading XCStats Data into CKDatabase Containers")
        var data = readDataFromCSV(fileName: "xcstats", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        let xcStats:[XCStatRecord] = loadXCStats(csv: csvRows)
        
        let container = CKContainer(identifier: "iCloud.xcstats.DLoader")
        let xcData = XCStatData(container: container)
        xcData.deleteAllRecords()
        print("Existing data deleted")
        
        xcData.saveRecords(records: xcStats)
        
        var predicate = NSPredicate(format: "athlete = %@", "Nirav Adunuthula")
        let records = xcData.loadRecords(predicate: predicate)
        print ("\(records.count) Records Loaded")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

