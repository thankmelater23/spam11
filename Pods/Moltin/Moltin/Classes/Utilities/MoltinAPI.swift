//
//  MoltinAPI.swift
//  Moltin
//
//  Created by Oliver Foggin on 14/02/2017.
//  Copyright © 2017 Oliver Foggin. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

public enum Result<T> {
    case success(result: T)
    case failure(error: Error)
}

struct MoltinAPI {
    
    static func objectRequest<T: JSONAPIDecodable>(request: URLRequestConvertible, completion: @escaping (Result<T?>) -> ()) {
        Router.auth.authenticate {
            Alamofire.request(request).responseJSON { response in
                self.processObject(response: response, completion: completion)
            }
        }
    }
    
    static func arrayRequest<T: JSONAPIDecodable>(request: URLRequestConvertible, completion: @escaping (Result<[T]>) -> ()) {
        Router.auth.authenticate {
            Alamofire.request(request).responseJSON { response in
                self.processArray(response: response, completion: completion)
            }
        }
    }
    
    static func arrayWithMetaRequest<T: JSONAPIDecodable>(request: URLRequestConvertible, completion: @escaping (Result<([T], JSON?)>) -> ()) {
        Router.auth.authenticate {
            Alamofire.request(request).responseJSON { response in
                self.processArrayWithMeta(response: response, completion: completion)
            }
        }
    }
    
    private static func processArrayWithMeta<T: JSONAPIDecodable>(response: DataResponse<Any>, completion: @escaping (Result<([T], JSON?)>) -> ()) {
        switch response.result {
        case .failure(let error):
            completion(Result.failure(error: error))
        case .success(let json):
            guard let json = json as? JSON,
                let jsonArray: [JSON] = "data" <~~ json else {
                    completion(Result.success(result: ([], nil)))
                    return
            }
            
            let array = [T].from(jsonArray: jsonArray, includedJSON: index("included" <~~ json))
            completion(Result.success(result: (array, "meta" <~~ json)))
        }
    }
    
    private static func processObject<T: JSONAPIDecodable>(response: DataResponse<Any>, completion: @escaping (Result<T?>) -> ()) {
        switch response.result {
        case .failure(let error):
            completion(Result.failure(error: error))
        case .success(let json):
            guard let json = json as? JSON,
                let objectJSON: JSON = "data" <~~ json,
                let object: T = T(json: objectJSON, includedJSON: index("included" <~~ json)) else {
                    completion(Result.success(result: nil))
                    return
            }
            
            completion(Result.success(result: object))
        }
    }
    
    private static func processArray<T: JSONAPIDecodable>(response: DataResponse<Any>, completion: @escaping (Result<[T]>) -> ()) {
        switch response.result {
        case .failure(let error):
            completion(Result.failure(error: error))
        case .success(let json):
            guard let json = json as? JSON,
                let jsonArray: [JSON] = "data" <~~ json else {
                    completion(Result.success(result: []))
                    return
            }
            
            let array = [T].from(jsonArray: jsonArray, includedJSON: index("included" <~~ json))
            completion(Result.success(result: array))
        }
    }
    
    private static func index(_ includeDictionary: [String : [JSON]]?) -> [String : JSON] {
        guard let includeDictionary = includeDictionary else {
            return [:]
        }
        
        var dictionary: [String : JSON] = [:]

        includeDictionary.forEach {
            _, array in
            
            array.forEach {
                guard let id : String = "id" <~~ $0 else {
                    return
                }
                
                dictionary[id] = $0
            }
        }
        
        return dictionary
    }
}
