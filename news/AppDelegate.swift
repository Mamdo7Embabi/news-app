//
//  AppDelegate.swift
//  news
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 3)
        // Override point for customization after application launch.
        self.customizeNavigation()
        self.getUserCountryCode()
       
        
        // self.enumerateFonts()
        //---------------------------------------------------------
        return true
    }
    
    func getUserCountryCode(){
        //get the country code of the user
        let locale = Locale.current
        print("user country code = \(locale.regionCode!)")
        APIConstants.CountryCode = locale.regionCode!
    }
    
    func customizeNavigation(){
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationBarAppearace.barTintColor = #colorLiteral(red: 0.2823529412, green: 0.7450980392, blue: 0.6823529412, alpha: 1)
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.shadowImage = UIImage()
        
        let attributes = [NSAttributedStringKey.font: UIFont(name: "HacenTunisiaBold", size: 28)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = attributes
  
   
        navigationBarAppearace.alpha = 0.5
    }

    
    func enumerateFonts()
    {
        for fontFamily in UIFont.familyNames
        {
            print("Font family name = \(fontFamily as String)")
            for fontName in UIFont.fontNames(forFamilyName: fontFamily as String)
            {
                print("- Font name = \(fontName)")
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
   }

    func applicationDidEnterBackground(_ application: UIApplication) {
   }

    func applicationWillEnterForeground(_ application: UIApplication) {
   }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

