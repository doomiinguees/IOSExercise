//
//  SceneDelegate.swift
//  SecondOne
//
//  Created by Tomás Domingues on 15/07/2025.
//

import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

	
