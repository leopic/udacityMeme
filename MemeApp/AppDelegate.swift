//
//  AppDelegate.swift
//  MemeApp
//
//  Created by Leo Picado on 6/27/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

}
