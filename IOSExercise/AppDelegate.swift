//
//  AppDelegate.swift
//  SecondOne
//
//  Created by Tomás Domingues on 15/07/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let fontName = "StarJediSpecialEdition"

        UILabel.appearance().font = UIFont(name: fontName, size: 18)
        UIButton.appearance().titleLabel?.font = UIFont(name: fontName, size: 18)
        UITextField.appearance().font = UIFont(name: fontName, size: 18)
        UITextView.appearance().font = UIFont(name: fontName, size: 18)
        UIApplication.shared.statusBarStyle = .lightContent
    
        return true
    }
    

    func configureGlobalFont() {
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

