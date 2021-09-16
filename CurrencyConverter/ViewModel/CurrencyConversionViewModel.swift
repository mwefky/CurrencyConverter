//
//  CurrencyConversionViewModel.swift
//  CurrencyConverter
//
//  Created by mina wefky on 15/09/2021.
//

import Foundation
import RxSwift
import RxRelay

struct CurrencyConversionViewModel {
    
    var currencyConversionvar = PublishSubject<CurrencyDTO>()
    var currencyConverRes: Observable<(CurrencyDTO)> {
        return currencyConversionvar.asObservable()
    }
    
    var customeErrorVar = PublishSubject<CustomeError>()
    var customeError: Observable<(CustomeError)> {
        return customeErrorVar.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    func convertCurrency(with amount: Double, fromCur: String, toCurr: String) {
        
        validateTransaction(with: amount, fromCur: fromCur, toCurr: toCurr)
    }
    
    func getIntialValues() {
        currencyConversionvar.onNext(CurrencyDTO(EURBalance: CurrencyValidator.shared.EURBalance, USDBalance: CurrencyValidator.shared.USDBalance, JPYBalance: CurrencyValidator.shared.JPYBalance, message: ""))
    }
    
    private func validateTransaction(with amount: Double, fromCur: String, toCurr: String) {
        if amount == 0.0 {
            postError(error: .noAmount)
        }
        if fromCur == toCurr {
            postError(error: .sameCurrencies)
        }
        if fromCur == "EUR" && amount > CurrencyValidator.shared.EURBalance {
            postError(error: .insufficientAmount)
        }
        if fromCur == "USD" && amount > CurrencyValidator.shared.USDBalance {
            postError(error: .insufficientAmount)
        }
        if fromCur == "JPY" && amount > CurrencyValidator.shared.JPYBalance {
            postError(error: .insufficientAmount)
        }
        performCurrencyConvertRequest(with: amount, fromCur: fromCur, toCurr: toCurr)
    }
    
    private func postError(error: CustomeError) {
        customeErrorVar.onNext(error)
        currencyConversionvar.disposed(by: disposeBag)
    }
    
    private func performCurrencyConvertRequest(with amount: Double, fromCur: String, toCurr: String) {
        ApiClient.convertCurrency(amount: amount, fromCur: fromCur, toCur: toCurr)
            .observeOn(MainScheduler.instance)
            .subscribe { (currencyRes) in
                updateCurrenciesValues(with: amount, toAmount: Double(currencyRes.amount ?? "0.0") ?? 0.0, fromCur: fromCur, toCurr: toCurr)
            } onError: { (error) in
                postError(error: .networkError)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateCurrenciesValues(with fromAmount: Double, toAmount: Double, fromCur: String, toCurr: String) {
        var calculateCommetionFee = false
        if CurrencyValidator.shared.numberOfTransactions > 5 {
            calculateCommetionFee = true
        }
        var commiton = 0.0
        if fromCur == "EUR" {
            CurrencyValidator.shared.EURBalance -= fromAmount
            if calculateCommetionFee {
                CurrencyValidator.shared.EURFees += (fromAmount * 0.7) / 100.0
                commiton = CurrencyValidator.shared.EURFees
            }
        } else if fromCur == "USD" {
            CurrencyValidator.shared.USDBalance -= fromAmount
            if calculateCommetionFee {
                CurrencyValidator.shared.USDFees += (fromAmount * 0.7) / 100.0
                commiton = CurrencyValidator.shared.USDFees
            }
        } else if fromCur == "JPY"{
            CurrencyValidator.shared.JPYBalance -= fromAmount
            if calculateCommetionFee {
                CurrencyValidator.shared.JPYFees += (fromAmount * 0.7) / 100.0
                commiton = CurrencyValidator.shared.JPYFees
            }
        }
        
        if toCurr == "EUR" {
            CurrencyValidator.shared.EURBalance += toAmount
        } else if toCurr == "USD" {
            CurrencyValidator.shared.USDBalance += toAmount
        } else if toCurr == "JPY"{
            CurrencyValidator.shared.JPYBalance += toAmount
        }
        
        CurrencyValidator.shared.numberOfTransactions += 1
        currencyConversionvar.onNext(CurrencyDTO(EURBalance: CurrencyValidator.shared.EURBalance, USDBalance: CurrencyValidator.shared.USDBalance, JPYBalance: CurrencyValidator.shared.JPYBalance, message: commiton > 0.0 ? "You have converted \(fromAmount) \(fromCur) to \(toAmount) \(toCurr). Commission Fee - \(commiton) \(fromCur)." : ""))
    }
}
