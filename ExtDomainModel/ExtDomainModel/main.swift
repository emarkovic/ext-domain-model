//
//  main.swift
//  ExtDomainModel
//
//  Created by Personal on 4/13/17.
//  Copyright © 2017 Ena Markovic. All rights reserved.
//

import Foundation

////////////////////////////////////
// String convertible
//
protocol CustomStringConvertible {
    func toString() -> String
}

////////////////////////////////////
// Math
//
protocol Mathematics {
    func add(_ to: Money) -> Money
    func remove(_ from: Money) -> Money
}

////////////////////////////////////
// Double extension 
//
extension Double {
    var USD: Money { return Money(amount: Int(self), currency: "USD") }
    
    var EUR: Money { return Money(amount: Int(self * 1.5), currency: "EUR") }
    
    var GBP: Money { return Money(amount: Int(self * 0.5), currency: "GBP") }
    
    var CAN: Money { return Money(amount: Int(self * 1.25), currency: "CAN") }
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
    public var amount : Int
    public var currency : String
    // I dont think it makes sense adding a description prop here
    
    public func convert(_ to: String) -> Money {
        var newAmount: Int?
        var newCurrency: String? = to;
        
        if self.currency == "USD" {
            if to == "GBP" {
                newAmount = (self.amount * 50) / 100
            } else if to == "EUR" {
                newAmount = (self.amount * 150) / 100
            } else if to == "CAN" {
                newAmount = (self.amount * 125) / 100
            } else {
                newCurrency = nil
            }
        } else if self.currency == "GBP" {
            if to == "USD" {
                // 1 gbp = 2 usd
                newAmount = (self.amount * 200) / 100
            } else if to == "EUR" {
                // 1 gbp = 3 eur
                newAmount = (self.amount * 300) / 100
            } else if to == "CAN" {
                // 1 gbp = 2.25 can
                newAmount = (self.amount * 225) / 100
            } else {
                newCurrency = nil
            }
        } else if self.currency == "EUR" {
            if to == "USD" {
                // 1 eur = 0.67 usd
                newAmount = (self.amount * 67) / 100
            } else if to == "GBP" {
                // 1 eur = 0.33 gbp
                newAmount = (self.amount * 33) / 100
            } else if to == "CAN" {
                // 1 eur = 0.83 can
                newAmount = (self.amount * 83) / 100
            } else {
                newCurrency = nil
            }
        } else if self.currency == "CAN" {
            if to == "USD" {
                // 1 can = 0.8 usd
                newAmount = (self.amount * 80) / 100
            } else if to == "GBP" {
                // 1 can = 0.4 gbp
                newAmount = (self.amount * 40) / 100
            } else if to == "EUR" {
                // 1 can = 1.2 eur
                newAmount = (self.amount * 120) / 100
            } else {
                newCurrency = nil
            }
        }
        
        if newAmount != nil && newCurrency != nil {
            return Money(amount: newAmount!, currency: newCurrency!)
        } else {
            return Money(amount: 0, currency: "")
        }
    }
    
    public func add(_ to: Money) -> Money {
        var newAmount: Int?
        if to.currency != self.currency {
            let selfConverted = self.convert(to.currency)
            newAmount = selfConverted.amount + to.amount
        } else {
            newAmount = to.amount + self.amount
        }
        
        return Money(amount: newAmount!, currency: to.currency)
    }
    
    public func remove(_ from: Money) -> Money {
        var newAmount: Int?
        if from.currency != self.currency {
            let selfConverted = self.convert(from.currency)
            newAmount = from.amount - selfConverted.amount
        } else {
            newAmount = from.amount - self.amount
        }
        
        return Money(amount: newAmount!, currency: from.currency)
    }
    
    public func toString() -> String {
        return "\(self.currency)\(Double(self.amount))"
    }
}

////////////////////////////////////
// Job
//
open class Job: CustomStringConvertible {
    fileprivate var title : String
    fileprivate var type : JobType
    // this is not necessary?
//    fileprivate var description: String
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
        
        func getValue() -> Any {
            switch self {
            case .Hourly(let value):
                return value
            case .Salary(let value):
                return value
            }
        }
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
        // this does not work...
//        self.description = self.toString()
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case JobType.Hourly:
            return Int(self.type.getValue() as! Double) * hours
        case JobType.Salary:
            return (self.type.getValue() as! Int)
        }
    }
    
    open func raise(_ amt : Double) {
        let currentPay = self.type.getValue()
        switch self.type {
        case JobType.Hourly:
            let newPay = currentPay as! Double + amt
            self.type = JobType.Hourly(newPay)
        case JobType.Salary:
            let newPay = currentPay as! Int + Int(amt)
            self.type = JobType.Salary(newPay)
        }
    }
    
    open func toString() -> String {
        var amtPaid = ""
        switch self.type {
        case JobType.Hourly:
            amtPaid = "$\(self.type.getValue())/hr"
        case JobType.Salary:
            amtPaid = "$\(self.type.getValue())"
        }
        return self.title + ": \(amtPaid)"
    }
}


////////////////////////////////////
// Person
//
open class Person: CustomStringConvertible {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    
    open var job : Job? {
        get {
            return self._job;
        }
        
        set(value) {
            if self.age >= 16 {
                self._job = value;
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return self._spouse
        }
        
        set(value) {
            if self.age >= 18 {
                self._spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        var jobStr: String?
        if self.job != nil {
            jobStr = self.job!.title
        } else {
            jobStr = "nil"
        }
        
        var spouseStr: String?
        if self.spouse != nil {
            spouseStr = self.spouse?.firstName
        } else {
            spouseStr = "nil"
        }
        
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(jobStr!) spouse:\(spouseStr!)]"
    }
}

////////////////////////////////////
// Family
//
open class Family: CustomStringConvertible {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil
            && (spouse1.age >= 21 || spouse2.age >= 21) {
            
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members.append(contentsOf: [spouse1, spouse2])
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        if self.members.count >= 1 {
            self.members.append(child)
            return true
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var income = 0;
        for member in members {
            if (member.job != nil) {
                let membInc = member.job!.type.getValue() as? Int
                if membInc != nil {
                    income += membInc!
                } else {
                    income += Int((member.job!.type.getValue() as? Double)!) * 40 * 4
                }
            }
        }
        print(income)
        return income
    }
    
    open func toString() -> String {
        let income = "Income: $\(self.householdIncome()) "
        var members = "Members: "
        for m in self.members {
            members += m.firstName + " "
        }
        return income + members
    }
}




