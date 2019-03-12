//
//  singleNewsObject.swift
//  news
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.

import Foundation
import ObjectMapper
import RealmSwift
class SingleNewsObject: Object, Mappable {
    

    @objc dynamic var urlToImage:String?
    @objc dynamic var newsDescription:String?
    @objc dynamic var newsTitle:String?
    @objc dynamic var author:String?
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
    
        urlToImage <- map["urlToImage"]
        newsDescription <- map["description"]
        newsTitle <- map["title"]
        author <- map["author"]
        
    }
    
}
