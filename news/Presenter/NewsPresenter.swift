//
//  NewsPresenter.swift
//  news
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.

import Foundation
class NewsPresenter {
    
    //get news data in NewsPresenter
    
    let newsService: NewsService
    var newsView: NewsView?
    
    init(newsService: NewsService) {
        self.newsService = newsService
    }
    
    func attachView(view: NewsView) {
        newsView = view
    }
    
    func detachView() {
        newsView = nil
    }
    
    func getnews(countryCode:String,pageSize:Int,pageNum:Int) {
        
        self.newsView?.startLoading()
        newsService.getNewsArr(countryCodeParam: countryCode, pageSizeParam: pageSize, pageNumParam: pageNum) { (result, isNetworkError ,newsData) in
            
            
            
            if result {
                
                if newsData.count == 0 {
                    self.newsView?.setEmptyNews()
                } else {
                    self.newsView?.finishLoading()
                    self.newsView?.setNews(news: newsData)
                    if pageNum == 1 {
                        self.newsService.setCachedData(news: newsData)
                    }
                }
            }else {
                
                
                if  pageNum == 1 {
                    //network error/first page
                    //if there is no connection the application will display the 5 cashed ads
                    //check cached data for first page only
                    self.newsService.getCachedNews(completion: { (cachedNewsArr) in
                        if cachedNewsArr.count == 0 {
                            //no data cached before
                            self.newsView?.showServerErrorAlert(isNetwork: isNetworkError)
                        }else {
                            //there was cached news found
                            self.newsView?.finishLoading()
                            self.newsView?.setNews(news: cachedNewsArr)
                        }
                    })
                }else {
                    //server error or network error / other pages
                    self.newsView?.showServerErrorAlert(isNetwork: isNetworkError)
                }
           }
        }
    }

}
