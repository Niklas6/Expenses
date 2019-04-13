//
//  Expense+CoreDataClass.swift
//  Expenses
//
//  Created by Knobel, Niklas (MU-Student) on 4/13/19.
//  Copyright © 2019 Tech Innovator. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Expense)
public class Expense: NSManagedObject {
    var date: Date? {
        get {
            return rawdate as Date?
        }
        set {
            rawdate = newValue as NSDate?
        }
    }
    
    convenience init?(name: String, amount: Double, date: Date?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: Expense.entity(), insertInto: managedContext)
        
        self.name = name
        self.amount = amount
        self.date = date
        
    }
}
