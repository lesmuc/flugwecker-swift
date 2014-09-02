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
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 4/255, green: 153/255, blue: 153/255, alpha: 1.0), NSFontAttributeName: UIFont(name: "Copperplate-Light", size: 16.0)]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(titleDict, forState: UIControlState.Normal)
        
        FBLoginView.self
        FBProfilePictureView.self

    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
    
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    
        return wasHandled
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow) -> Int {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return Int(UIInterfaceOrientationMask.Landscape.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.Portrait.toRaw())
        }
    }
    
}

