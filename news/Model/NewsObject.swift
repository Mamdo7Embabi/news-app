//
//  NewsObject.swift
//  news
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.

import Foundation
import ObjectMapper

struct NewsObject: Mappable {
    
  
    var articles: [SingleNewsObject]?

    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        articles <- map["articles"]

        
    }
    
}
