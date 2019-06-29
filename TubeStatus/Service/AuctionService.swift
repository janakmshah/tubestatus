//
//  AuctionService.swift
//  FCAuctions
//
//  Created by Janak Shah on 18/06/2019.
//  Copyright © 2019 App Ktchn. All rights reserved.
//

import Foundation

class Service: NSObject {
    static let shared = Service()

    func fetchAuctions(completion: @escaping ([Line]?, Error?) -> Void) {
        
        //TfL Rail
        //DLR
        //Tram
        
        //https://tfl.gov.uk/tube-dlr-overground/status/#lines-status
        //https://api.tfl.gov.uk/swagger/ui/index.html#!/Line/Line_MetaSeverity
        
        let tubeString = "https://api.tfl.gov.uk/line/mode/tube,overground,dlr/status"
        guard let tubeUrl = URL(string: tubeString) else { return }
        
        var linesArray = [Line]()
        var globalError: Error?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        URLSession.shared.dataTask(with: tubeUrl) { [weak self] (data, _, err) in
            if let err = err {
                DispatchQueue.main.async {
                    globalError = err
                }
            } else if let data = data {
                self?.decodeAuctions(jsonData: data, completion: {(lines, tubeDecodeError) in
                    if let tubeDecodeError = tubeDecodeError {
                        globalError = tubeDecodeError
                    } else if let lines = lines {
                        linesArray = linesArray + lines
                    }
                })
            }
            dispatchGroup.leave()
            }.resume()
            
        dispatchGroup.notify(queue: .main) {
            completion(linesArray, globalError)
        }
        

    }

    func decodeAuctions(jsonData: Data, completion: @escaping ([Line]?, Error?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let auctionResponse = try decoder.decode([Line].self, from: jsonData)
            DispatchQueue.main.async {
                completion(auctionResponse, nil)
            }
        } catch let jsonErr {
            DispatchQueue.main.async {
                print(jsonErr)
                completion(nil, jsonErr)
            }
        }
    }

}
