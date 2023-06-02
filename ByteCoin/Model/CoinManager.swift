//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Sandalu De Silva on 2023-05-31.
//

import Foundation

protocol CoinManagerDelegate{
    
    func didUpdateCurrency(rate:Double)
}


struct CoinManager{
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "55bce317-c1ea-4667-8386-d90fd4958892"
    var selectedCurrency : String?
    
    var delegate : CoinManagerDelegate?
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    mutating func getCoinPrice (for currency: String) {
        selectedCurrency = currency
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    
    func performRequest(urlString : String){
        //Create a URL
        if let url = URL(string: urlString){
            
            
            //Create a URL Session
            let session = URLSession(configuration: .default)
            
            //Give url Session  a task
            let task = session.dataTask(with: url) { data, response, error in
                
                if let err = error{
                    print("ERROR OCCURED !\(err)")
                    return
                }
                
                let decoder = JSONDecoder()
            
                if let safeData = data{
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString ?? "Hello")
                    
                    do{
                        let result = try decoder.decode(CurrencyModel.self, from: safeData)
                        print("Result \(result.rate)")
                        
                        delegate?.didUpdateCurrency(rate: result.rate)
                    }
                    catch{
                        print(error)
                    }
                    
                }
            }
            
            //Start the task
            task.resume()
        }
    }
}
