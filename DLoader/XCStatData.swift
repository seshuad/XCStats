//
//  XCStatData.swift
//
//  Loads XCStat data into iCloud Database Containers.
//  Created by Seshu Adunuthula on 1/17/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import Foundation
import CloudKit

enum Division : String {
    case V = "V"
    case JV = "JV"
    case So = "So"
    case Jr = "Jr"
    case Fr = "Fr"
    case FS = "F/S"
}

struct XCStatRecord {
    var id: String
    var school: String
    var athelte: String
    var eventDate: Date
    var eventName: String
    var eventCourse: String
    var distance: Double
    var division: Division
    var placement: Int
    var totalRunners: Int
    var stdDev: Double
    var time: String
    var pace: String
    var notes: String?
}

class XCStatData {
    let container: CKContainer
    
    init (container: CKContainer) {
        self.container = container
    }
    
    func saveRecords(records: [XCStatRecord]) {
        print("Saving to Cloud Container")
        let publicDB = container.publicCloudDatabase
        let group = DispatchGroup()
        
        for record in records {
            let ckr = CKRecord(recordType: "XCStatRecord", recordID: CKRecordID(recordName: record.id))
            ckr["id"] = record.id as NSString
            ckr["school"] = record.school as NSString
            ckr["athlete"] = record.athelte as NSString
            ckr["eventDate"] = record.eventDate as NSDate
            ckr["eventName"] = record.eventName as NSString
            ckr["eventCourse"] = record.eventCourse as NSString
            ckr["distance"] = record.distance as NSNumber
            ckr["division"] = record.division.rawValue as NSString
            ckr["placement"] = record.placement as NSNumber
            ckr["totalRunners"] = record.totalRunners as NSNumber
            ckr["stdDev"] = record.stdDev as NSNumber
            ckr["time"] = record.time as NSString
            ckr["pace"] = record.pace as NSString
            ckr["notes"] = record.notes as! NSString
            
            group.enter()
            publicDB.save(ckr) { (ckr, error) -> Void in
                guard error == nil else {
                    print("Error saving record: ", error)
                    group.leave()
                    return
                }
                group.leave()
                print("Successfully saved record: ", record)
            }
        }
        
        group.wait()
        print("\(records.count) Records saved...")
    }
    
    func loadRecords(predicate: NSPredicate) -> [XCStatRecord] {
        var records:[XCStatRecord] = []
        let query = CKQuery(recordType: "XCStatRecord", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "eventDate", ascending: false)]

        var queryResults:[CKRecord] = []
        let group = DispatchGroup()
        group.enter()
        
        let publicDB = container.publicCloudDatabase
        publicDB.perform(query, inZoneWith: nil) {results, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Refresh: \(error!)")
                }
                group.leave()
                return
            }
            
            queryResults = results!
            print ("results (in handler) \(queryResults.count)")
            group.leave()
        }
        
        group.wait()
        print ("results \(queryResults.count)")
        
        for record in queryResults {
            let division = Division(rawValue: record.object(forKey: "division") as! String)
            let xcRecord = XCStatRecord(id: record.object(forKey: "id") as! String,
                                        school: record.object(forKey: "school") as! String,
                                        athelte: record.object(forKey: "athlete") as! String,
                                        eventDate: record.object(forKey: "eventDate") as! Date,
                                        eventName: record.object(forKey: "eventName") as! String,
                                        eventCourse: record.object(forKey: "eventCourse") as! String,
                                        distance: record.object(forKey: "distance") as! Double,
                                        division: division!,
                                        placement: record.object(forKey: "placement") as! Int,
                                        totalRunners: record.object(forKey: "totalRunners") as! Int,
                                        stdDev: record.object(forKey: "stdDev") as! Double,
                                        time: record.object(forKey: "time") as! String,
                                        pace: record.object(forKey: "pace") as! String,
                                        notes: record.object(forKey: "notes") as! String)
            records.append(xcRecord)
        }
        
        return records
    }
    
    func deleteAllRecords() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "XCStatRecord", predicate: predicate)
        
        var queryResults:[CKRecord] = []
        let group = DispatchGroup()
        group.enter()
        
        let publicDB = container.publicCloudDatabase
        publicDB.perform(query, inZoneWith: nil) {results, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Refresh: \(error!)")
                }
                return
            }
            
            queryResults = results!
            group.leave()
        }
        
        group.wait()
        
        for record in queryResults {
            let recordID = CKRecordID(recordName: record.object(forKey: "id") as! String)
            group.enter()
            publicDB.delete(withRecordID: recordID) { (recordID, error) -> Void in
                guard error == nil else {
                    DispatchQueue.main.async {
                        print("Cloud Query Error - Refresh: \(error!)")
                    }
                    group.leave()
                    return
                }
                group.leave()
            }
        }
        
        group.wait()
        print ("\(queryResults.count) Records Deleted")
    }
    
}
