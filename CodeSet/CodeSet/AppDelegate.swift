//
//  AppDelegate.swift
//  CodeSet
//
//  Created by LangFZ on 2018/10/17.
//  Copyright © 2018 LangFZ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = MetalTestController.init()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

