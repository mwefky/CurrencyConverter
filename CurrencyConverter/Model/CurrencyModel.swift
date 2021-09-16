//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by mina wefky on 15/09/2021.
//
import Foundation

// MARK: - CurrencyModel
struct CurrencyModel: Codable {
    let amount, currency: String?
}

struct CurrencyDTO {
    
    internal init(EURBalance: Double, USDBalance: Double, JPYBalance: Double, message: String) {
        self.EURBalance = EURBalance
        self.USDBalance = USDBalance
        self.JPYBalance = JPYBalance
        self.message = message
    }
    
    let EURBalance: Double
    let USDBalance: Double
    let JPYBalance: Double
    let message: String
    
}
