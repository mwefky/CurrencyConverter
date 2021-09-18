//
//  CurrencyConversionMainViewController.swift
//  CurrencyConverter
//
//  Created by mina wefky on 15/09/2021.
//

import UIKit
import RxSwift
import iOSDropDown

class CurrencyConversionMainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var JPYAmountLabel: UILabel!
    @IBOutlet weak var usdAmountLabel: UILabel!
    @IBOutlet weak var eurAmountLabel: UILabel!
    @IBOutlet weak var curFromTextField: UITextField!
    @IBOutlet weak var curToTextField: UITextField!
    @IBOutlet weak var curFromDropDown: DropDown!
    @IBOutlet weak var curToDropDown: DropDown!
    @IBOutlet weak var submitBtn: UIButton!
    
    // MARK: - variables
    var currencyViewModel = CurrencyConversionViewModel()
    var disoseBag = DisposeBag()
    var fromCur = CurrencyName.EUR.rawValue
    var toCur = CurrencyName.USD.rawValue
    var amount = 0.0
    
    var alert: UIAlertController?
    var loadingIndicator: UIActivityIndicatorView?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Currency converter"
        bindViewModel()
        initDropDown()
        initViews()
    }
    
    // MARK: - UI initialization
    
    func initDropDown() {
        
        curFromDropDown.optionArray = [CurrencyName.EUR.rawValue, CurrencyName.USD.rawValue, CurrencyName.JPY.rawValue]
        curToDropDown.optionArray = [CurrencyName.EUR.rawValue, CurrencyName.USD.rawValue, CurrencyName.JPY.rawValue]
        curFromDropDown.text = CurrencyName.EUR.rawValue
        curToDropDown.text = CurrencyName.USD.rawValue
        curFromDropDown.selectedIndex = 0
        curToDropDown.selectedIndex = 1
        curFromDropDown.didSelect { [weak self] (selectedText, _, _) in
            self?.fromCur = selectedText
        }
        
        curToDropDown.didSelect { [weak self] (selectedText, _, _) in
            self?.toCur = selectedText
        }
    }
    
    func initViews() {
        
        currencyViewModel.getIntialValues()
        
        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator?.hidesWhenStopped = true
        loadingIndicator?.style = UIActivityIndicatorView.Style.medium
        
        submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
        submitBtn.layer.masksToBounds = true
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        curFromTextField.resignFirstResponder()
        showLoadingIndecator()
        currencyViewModel.convertCurrency(with: Double(curFromTextField.text ?? "") ?? 0.0, fromCur: CurrencyName(rawValue: fromCur) ?? .EUR, toCurr: CurrencyName(rawValue: toCur) ?? .USD)
    }
    
    private func showLoadingIndecator() {
        
        guard let loadingIndicator = loadingIndicator, let alert = alert else {return}
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(with title: String, message: String) {
        dismiss(animated: false, completion: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - binding View Model
    func bindViewModel() {
        currencyViewModel.currencyConverRes.subscribe(onNext: { [weak self] (curencies) in
            self?.updateView(curencies: curencies)
        }).disposed(by: disoseBag)
        
        currencyViewModel.customeError.subscribe(onNext: { [weak self] (err) in
            switch err {
            case.noAmount:
                self?.showAlert(with: "Error", message: "Please enter Amount to convert")
            case .sameCurrencies:
                self?.showAlert(with: "Error", message: "Can't convert to the same currency")
            case .insufficientAmount:
                self?.showAlert(with: "Error", message: "Insufficient currency balance")
            case .networkError:
                self?.showAlert(with: "Error", message: "Network error")
            }
        }).disposed(by: disoseBag)
    }
    
    private func updateView(curencies: CurrencyDTO) {
        dismiss(animated: false, completion: nil)
        eurAmountLabel.text = "\(String(format: "%.2f", curencies.EURBalance)) EUR"
        usdAmountLabel.text = "\(String(format: "%.2f", curencies.USDBalance)) USD"
        JPYAmountLabel.text = "\(String(format: "%.2f", curencies.JPYBalance)) BGN"
        if curencies.message != "" {
            showAlert(with: "Currency converted", message: curencies.message)
        }
        curFromTextField.text = ""
    }
}
