//
//  AppDelegate.swift
//  AutoHeader
//
//  Created by Maximilian Kraus on 05.03.17.
//  Copyright © 2017 Maximilian Kraus. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = ViewController()
    window.makeKeyAndVisible()
    self.window = window
    
    return true
  }
}

