//
//  RequestsService.swift
//  homeWork_16
//
//  Created by Дмитрий Яковлев on 18.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import Foundation

//MARK:- Struct for generic requests
struct RequestsService{
    
    var netModel = NetModel()
    
    func sendGetReqest<T:Decodable>(
         type: T.Type,
         endPoint: String,
         completion: @escaping(T) -> Void,
         failure: ((String) -> Void)?) {
         
         netModel.sendRequest(
             endPoint: endPoint,
             httpMethod: .GET,
             headers: ["Content-Type": "application/json"],
             parseType: type
             
         ) { result in
             switch result {
             case .error(let error):
                 print(error)
                 failure?(error)
             case .some(let object):
//                 dump(object)
                 completion(object)
             }
         }
     }
}
