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
    
    func convertCurrency(with amount: Double, fromCur: CurrencyName, toCurr: CurrencyName) {
        
        validateTransaction(with: amount, fromCur: fromCur, toCurr: toCurr)
    }
    
    func getIntialValues() {
        currencyConversionvar.onNext(CurrencyDTO(EURBalance: CurrencyValidator.shared.EURBalance, USDBalance: CurrencyValidator.shared.USDBalance, JPYBalance: CurrencyValidator.shared.JPYBalance, message: ""))
    }
    
    private func validateTransaction(with amount: Double, fromCur: CurrencyName, toCurr: CurrencyName) {
        if amount == 0.0 {
            postError(error: .noAmount)
        }
        if fromCur == toCurr {
            postError(error: .sameCurrencies)
        }
        switch fromCur {
        
        case .EUR:
            if amount > CurrencyValidator.shared.EURBalance {
                postError(error: .insufficientAmount)
            }
        case .USD:
            if amount > CurrencyValidator.shared.USDBalance {
                postError(error: .insufficientAmount)
            }
        case .JPY:
            if amount > CurrencyValidator.shared.JPYBalance {
                postError(error: .insufficientAmount)
            }
        }
        performCurrencyConvertRequest(with: amount, fromCur: fromCur, toCurr: toCurr)
    }
    
    private func postError(error: CustomeError) {
        customeErrorVar.onNext(error)
        currencyConversionvar.disposed(by: disposeBag)
    }
    
    private func performCurrencyConvertRequest(with amount: Double, fromCur: CurrencyName, toCurr: CurrencyName) {
        ApiClient.convertCurrency(amount: amount, fromCur: fromCur.rawValue, toCur: toCurr.rawValue)
            .observeOn(MainScheduler.instance)
            .subscribe { (currencyRes) in
                updateCurrenciesValues(with: amount, toAmount: Double(currencyRes.amount ?? "0.0") ?? 0.0, fromCur: fromCur, toCurr: toCurr)
            } onError: { (error) in
                postError(error: .networkError)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateCurrenciesValues(with fromAmount: Double, toAmount: Double, fromCur: CurrencyName, toCurr: CurrencyName) {
        var calculateCommetionFee = false
        if CurrencyValidator.shared.numberOfTransactions > 5 {
            calculateCommetionFee = true
        }
        var commiton = 0.0
        switch fromCur {
        
        case .EUR:
            CurrencyValidator.shared.EURBalance -= fromAmount
            if calculateCommetionFee {
                CurrencyValidator.shared.EURFees += (fromAmount * 0.7) / 100.0
                commiton = CurrencyValidator.shared.EURFees
            }
        case .USD:
            CurrencyValidator.shared.USDBalance -= fromAmount
            if calculateCommetionFee {
                CurrencyValidator.shared.USDFees += (fromAmount * 0.7) / 100.0
                commiton = CurrencyValidator.shared.USDFees
            }
        case .JPY:
            CurrencyValidator.shared.JPYBalance -= fromAmount
            if calculateCommetionFee {
                CurrencyValidator.shared.JPYFees += (fromAmount * 0.7) / 100.0
                commiton = CurrencyValidator.shared.JPYFees
            }
            
        }
        
        switch toCurr {
        case .EUR:
            CurrencyValidator.shared.EURBalance += toAmount
        case .USD:
            CurrencyValidator.shared.USDBalance += toAmount
        case .JPY:
            CurrencyValidator.shared.JPYBalance += toAmount
        }
        
        CurrencyValidator.shared.numberOfTransactions += 1
        currencyConversionvar.onNext(CurrencyDTO(EURBalance: CurrencyValidator.shared.EURBalance,
                                                 USDBalance: CurrencyValidator.shared.USDBalance,
                                                 JPYBalance: CurrencyValidator.shared.JPYBalance,
                                                 message: commiton > 0.0 ? "You have converted \(fromAmount) \(fromCur) to \(toAmount) \(toCurr). Commission Fee - \(commiton) \(fromCur)." : ""))
    }
}
