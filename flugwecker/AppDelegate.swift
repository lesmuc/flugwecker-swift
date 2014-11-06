//
//  AppDelegate.swift
//  flugwecker
//
//  Created by Udo von Eynern on 08.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    
    func applicationDidFinishLaunching(application: UIApplication) {
        
        let color = UIColor(red: 4/255, green: 153/255, blue: 153/255, alpha: 1.0)

        if let font = UIFont(name: "Copperplate-Light", size: 16.0) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font,
                NSForegroundColorAttributeName: color], forState: UIControlState.Normal)
        }
        
        if let font = UIFont(name: "Copperplate-Light", size: 12.0) {
            UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: font,
                NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        }

        Parse.setApplicationId("NLosrHjg3bS8kXsQYdxgcdJHnyC6uyAryJkWipiA", clientKey:"HMZmySpXR04Vzvf9X2tlnigdNoVtLGXpZwbetnCs")
        PFFacebookUtils.initializeFacebook()
        
        PFTwitterUtils.initializeWithConsumerKey("YOUR CONSUMER KEY",
            consumerSecret:"YOUR CONSUMER SECRET")


        FBLoginView.self
        FBProfilePictureView.self
        
        PFUser.enableAutomaticUser()
        
        Airport.registerSubclass()
        Region.registerSubclass()
        Flight.registerSubclass()
        FlightConnection.registerSubclass()
        Trip.registerSubclass()
        User.registerSubclass()
        
        self.window!.tintColor = color
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String,
        annotation: AnyObject?) -> Bool {
            return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
                withSession:PFFacebookUtils.session())
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
    
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    
        return wasHandled
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow) -> Int {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return Int(UIInterfaceOrientationMask.Landscape.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        }
    }
    
}

