//
//  AppDelegate.swift
//  MobileClientPinpointTest
//
//  Created by Schmelter, Tim on 8/1/19.
//  Copyright © 2019 Amazon Web Services. All rights reserved.
//

import UIKit

import AWSMobileClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        AWSDDLog.sharedInstance.logLevel = .verbose
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)

        AWSMobileClient.sharedInstance().initialize { userState, error in
            if let error = error {
                print("Error initializing AWSMobileClient: \(error)")
                return
            }

            guard let userState = userState else {
                print("userState unexpectedly nil initializing AWSMobileClient")
                return
            }

            print("Initialized AWSMobileClient: \(userState)")
        }
        return true
    }

}
