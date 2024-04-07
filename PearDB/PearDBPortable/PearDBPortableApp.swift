//
//  PearDBPortableApp.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 18/01/24.
//

import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            let hostingController = UIHostingController(rootView: ContentView())
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = hostingController
            window?.makeKeyAndVisible()
        
        return true
    }
}
