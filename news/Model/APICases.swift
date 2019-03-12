//
//  APICases.swift
//  news
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.
//
import Foundation
import Moya


struct APIConstants {
    static let ApiKey = "cd277d95c9db41bfa97832f10b5c3d6d"
    static var CountryCode = "US"
}

enum API {
    case getNews(countryCode: String, pageSize:Int ,pageNum: Int )
}


let APIProvider = MoyaProvider<API>()

extension API: TargetType {

    var baseURL: URL { return URL(string: "https://newsapi.org/v2")! }
    var path: String {
            switch self {
            
            case .getNews( _ , _ , _) :
                return "/top-headlines"
            }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNews:
            return .get
     
        }
    }
    
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
       
     
        case let .getNews(countryCode , pageSize , pageNum):  // Always sends parameters in URL, regardless of which HTTP method is used
            return .requestParameters(parameters: ["country": countryCode, "pageSize": pageSize , "page":pageNum , "apiKey" : APIConstants.ApiKey ], encoding: URLEncoding.queryString)
            
            
        }
    }
    
    
    var headers: [String: String]? {
        return ["Content-type": "json"]
    }
    
}



