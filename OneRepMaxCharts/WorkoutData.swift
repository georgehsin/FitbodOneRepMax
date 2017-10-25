//
//  WorkoutData.swift
//  OneRepMaxCharts
//
//  Created by George Hsin on 10/23/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation

// MARK: - Singleton

final class WorkoutData {
    private init() { }
    
    // MARK: Shared Instance
    static let sharedInstance = WorkoutData()
    
    var dictData = [String:[(String, Int)]]()
    var exercises = [String]()
    
    func getWorkoutData(completion: ([String:[(String, Int)]], [String]) -> ()) {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: "workoutData", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                
                let lines = data.components(separatedBy: .newlines)
                for line in lines {
                    let set = line.components(separatedBy: ",")
                    if set.count < 5 {
                        continue
                    }
                    let oneRepMax = brzyckiFormula(weight: set[4], reps: set[3])
                    if dictData.keys.contains(set[1]) {
                        // if dictionary contains the exercise, calculate and compare one rep max for global and for date
                        if dictData[set[1]]!.last!.0 == set[0] {
                            //check if date max for date exists and if it is greater
                            let last = dictData[set[1]]!.count - 1
                            if dictData[set[1]]!.last!.1 < oneRepMax{
                                dictData[set[1]]![last].1 = oneRepMax
                            }
                        }
                        else {
                            //if date does not yet exists, push (date, oneRepMax) tuple into exercise array
                            dictData[set[1]]!.append((set[0], oneRepMax))
                        }
                        
                        if dictData[set[1]]![0].1 < oneRepMax {
                            //check if exercise current set max is greater than overall exercise max
                            dictData[set[1]]![0].1 = oneRepMax
                        }
                        
                    }
                    else {
                        // if dictionary does not contain the exercise, calculate one rep max, and set it for global and for date
                        exercises.append(set[1])
                        dictData[set[1]] = []
                        dictData[set[1]]!.append(("max", oneRepMax))
                        dictData[set[1]]!.append((set[0], oneRepMax))
                    }
                }
                completion(dictData, exercises)
            } catch let error as NSError {
                NSLog("OneRepMaxTableController - Error: \(error)")
            }
        
        }
        else {
            print("No Data Found - please add data.txt file")
        }
    }

    func brzyckiFormula(weight: String, reps: String) -> Int {
        let den = 1.0278 - (0.0278 * Double(reps)!)
        let oneRepMax = Double(weight)!/den
        return Int(round(oneRepMax))
    }
    
}
