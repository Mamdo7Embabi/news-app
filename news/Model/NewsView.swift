//
//  NewsView.swift
//  news
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.

import Foundation

protocol NewsView: NSObjectProtocol {
    
    func startLoading()
    func finishLoading()
    func setNews(news: [SingleNewsObject])
    func setEmptyNews()
    func showServerErrorAlert(isNetwork:Bool)
    
}
