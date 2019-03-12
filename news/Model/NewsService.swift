//
//  NewsService.swift
//  news
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.

import Foundation
import RealmSwift
class NewsService {
    
    func getNewsArr(countryCodeParam:String,pageSizeParam:Int,pageNumParam:Int, completion: @escaping (_ result: Bool ,_ isNetworkError : Bool , _ newsArr: [SingleNewsObject])->()){
        
        APIProvider.request(.getNews(countryCode: countryCodeParam, pageSize: pageSizeParam, pageNum: pageNumParam)) { result in
            switch result {
            case let .success(moyaResponse):
                // do something with the response data or statusCode
                do {
                    let newsObj:NewsObject? = try moyaResponse.mapObject(NewsObject.self)
                    if let newsObj = newsObj {
                        
                        if let articles = newsObj.articles{
                            completion(true,false,articles)
                        }else {
                            completion(false,false,[])
                        }
                        
                    } else {
                        completion(false,false,[])
                    }
                } catch {
                    completion(false,false,[])
                }
            case let .failure(error):
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
                print("get news request error =\(error.localizedDescription)")
                if error.localizedDescription == "The Internet connection appears to be offline." {
                    completion(false,true,[])
                }else {
                    completion(false,false,[])
                }
            }
        }
    }
    
    func setCachedData(news:[SingleNewsObject]){
        
        var allNewsData = [SingleNewsObject]()
        allNewsData = news
        
        //application will cash the first 5 headlines
        // Get the default Realm
        let realm = try! Realm()
        //get data cached in realm
        let cachedNews = realm.objects(SingleNewsObject.self)
        //if there was data found

        var chachedNewsData = [SingleNewsObject]()
        chachedNewsData.append(contentsOf: cachedNews)
        
        if chachedNewsData.count > 0 {
            for oneObj in chachedNewsData {
                if let title = oneObj.newsTitle{
                    if let cachedObj = realm.objects(SingleNewsObject.self).filter("newsTitle == %@",title).first{
                        var newsobj = SingleNewsObject()
                        newsobj = cachedObj
                        if !newsobj.isInvalidated{
                            try! realm.write {
                                realm.delete(newsobj)
                            }
                        }
                    }
                }
            }
        }
        //then save first five headlines
       for i in 0...4 {
           //to check in that index found in news array or not
            if i < allNewsData.count {
                // Persist your data easily
                try! realm.write {
                    realm.add(allNewsData[i])
                }
            }else {
                return
            }
        }
   }
    
    func getCachedNews(completion: @escaping (_ newsArr: [SingleNewsObject])->()){
        //if there is no connection the application will display the 5 cashed ads
        // Get the default Realm
        var cachedNewsArr = [SingleNewsObject]()
        let realm = try! Realm()
        let cachedNews = realm.objects(SingleNewsObject.self)
        if cachedNews.count > 0 {
            
            print("cachedNews.count = \(cachedNews.count)")
            cachedNewsArr.append(contentsOf: cachedNews)
            completion(cachedNewsArr)
            
        }else {
            print("there is no cached news")
            completion([])
        }
    }
    
    
}
