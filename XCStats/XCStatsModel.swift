//
//  XCStatsModel.swift
//  XCStats
//
//  Created by Seshu Adunuthula on 1/17/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import UIKit
import CloudKit

class XCStatsModel: NSObject {
    var xcStatRecords:[XCStatRecord] = []
    var xcData:XCStatData
    
    override init() {
        let container = CKContainer(identifier: "iCloud.xcstats.DLoader")
        xcData = XCStatData(container: container)
        var predicate = NSPredicate(value: true)
        xcStatRecords = xcData.loadRecords(predicate: predicate)
        print("\(xcStatRecords.count) records loaded")
    }
    
    func getAllAthletes() -> [String] {
        var athletes = Set<String>()
        
        for row in xcStatRecords {
            athletes.insert(row.athelte)
        }
        
        return Array(athletes)
    }
    
    func getAthleteRecords(athlete: String) -> [XCStatRecord] {
        var records:[XCStatRecord] = []
        
        for row in xcStatRecords {
            if (row.athelte == athlete) {
                records.append(row)
            }
        }
        
        return records
    }
}
