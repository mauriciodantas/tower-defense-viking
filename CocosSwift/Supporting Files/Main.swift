//
//  Main.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

@UIApplicationMain class AppDelegate : CCAppDelegate {

	// MARK: Life Cycle
	override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
		setupCocos2dWithOptions([CCSetupShowDebugStats: true])

		return true
	}

	// MARK: Override Methods
	override func startScene() -> (CCScene) {
		return LoadingScene()
	}

	// MARK: Multi task delegates
	override func applicationWillResignActive(application:UIApplication) {
		print("Resign Active")
	}
	
	override func applicationDidBecomeActive(application:UIApplication) {
		print("Become Active")
	}
	
	override func applicationDidEnterBackground(application:UIApplication) {
		print("Enter Background")
	}
	
	override func applicationWillEnterForeground(application:UIApplication) {
		print("Enter Foreground")
	}
}
