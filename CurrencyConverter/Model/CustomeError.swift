//
//  CustomeError.swift
//  CurrencyConverter
//
//  Created by mina wefky on 15/09/2021.
//

import Foundation


enum CustomeError: Error {
    case sameCurrencies
    case noAmount
    case insufficientAmount
    case networkError
}
