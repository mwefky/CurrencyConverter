//
//  CurrencyValidator.swift
//  CurrencyConverter
//
//  Created by mina wefky on 16/09/2021.
//

import Foundation

struct CurrencyValidator {
    
    static var shared = CurrencyValidator()
    
    var EURBalance: Double {
        get {
            return UserDefaults.standard.double(forKey: "EURBalance")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "EURBalance")
            UserDefaults.standard.synchronize()
        }
    }
    
    var USDBalance: Double {
        get {
            return UserDefaults.standard.double(forKey: "USDBalance")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "USDBalance")
            UserDefaults.standard.synchronize()
        }
    }
    
    var JPYBalance: Double {
        get {
            return UserDefaults.standard.double(forKey: "JPYBalance")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "JPYBalance")
            UserDefaults.standard.synchronize()
        }
    }
    
    var numberOfTransactions: Int {
        get {
            return UserDefaults.standard.integer(forKey: "numberOfTransactions")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "numberOfTransactions")
            UserDefaults.standard.synchronize()
        }
    }
    
    var EURFees: Double {
        get {
            return UserDefaults.standard.double(forKey: "EURFees")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "EURFees")
            UserDefaults.standard.synchronize()
        }
    }
    
    var USDFees: Double {
        get {
            return UserDefaults.standard.double(forKey: "USDFees")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "USDFees")
            UserDefaults.standard.synchronize()
        }
    }
    
    var JPYFees: Double {
        get {
            return UserDefaults.standard.double(forKey: "JPYFees")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "JPYFees")
            UserDefaults.standard.synchronize()
        }
    }
    
}
