//
//  CSVReader.swift
//  XCStats
//
//  Create XCStats Database Scheme and load records from a file.
//  Created by Seshu Adunuthula on 1/17/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import Foundation

func readDataFromCSV(fileName:String, fileType: String)-> String!{
    guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
        else {
            return nil
    }
    do {
        var contents = try String(contentsOfFile: filepath, encoding: .utf8)
        contents = cleanRows(file: contents)
        return contents
    } catch {
        print("File Read Error for file \(filepath)")
        return nil
    }
}


func cleanRows(file:String)->String{
    var cleanFile = file
    cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
    //cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
    //cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
    return cleanFile
}

func csv(data: String) -> [[String]] {
    var result: [[String]] = []
    var rows = data.components(separatedBy: "\n")
    
    //remove the header
    rows.remove(at: 0)
    for row in rows {
        let columns = row.components(separatedBy: ",")
        result.append(columns)
    }
    
    return result
}

func loadXCStats(csv: [[String]]) -> [XCStatRecord] {
    var records:[XCStatRecord] = []
    
    for row in csv {
        if (row.count < 12) {
            continue
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yy"
        let date = dateFormatter.date(from: row[2])
        
        let pl = row[7].components(separatedBy: "/")
        let id = UUID().uuidString
        let distance = Double(row[5])
        let stdDev = Double(row[8])
        let pl0 = Int(pl[0])
        let pl1 = Int(pl[1])
        let notes = row[11]
        let division = Division(rawValue: row[6])
        
        let record = XCStatRecord(id: id, school: row[0], athelte: row[1], eventDate: date,
                                  eventName: row[3], eventCourse: row[4], distance: distance,
                                  division: division!, placement: pl0, totalRunners: pl1,
                                  stdDev: stdDev, time: row[9], pace: row[10], notes: notes)
        records.append(record)
    }
    
    return records
}


