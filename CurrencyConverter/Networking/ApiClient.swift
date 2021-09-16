//
//  APIManager.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//

import Foundation
import RxSwift
import Alamofire

class ApiClient {
    
    static func convertCurrency(amount: Double, fromCur: String, toCur: String) -> Observable<CurrencyModel> {
        return request(ApiRouter.convertCurrency(amount: amount, fromCur: fromCur, toCur: toCur))
    }
    
    // MARK: - The request function to get results in an Observable
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable {  (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
