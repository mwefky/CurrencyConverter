//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by mina wefky on 15/09/2021.
//

import XCTest
import RxSwift
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {

    var mockNetwork: ApiClient!
    let disposeBag = DisposeBag()
    var currencyViewModel = CurrencyConversionViewModel()
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        mockNetwork = nil
        super.tearDown()
    }
    
    func testValidateNetWorkCallsForVenue() {
        
        let promise = expectation(description: "Status code: 200")
        ApiClient.convertCurrency(amount: 20, fromCur: "USD", toCur: "EUR")
            .subscribe(onNext: { _ in
                promise.fulfill()
            }, onError: { (error) in
                XCTFail("Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 5)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
