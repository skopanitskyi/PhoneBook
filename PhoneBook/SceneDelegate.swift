//
//  SceneDelegate.swift
//  PhoneBook
//
//  Created by Копаницкий Сергей on 30.07.2020.
//  Copyright © 2020 Копаницкий Сергей. All rights reserved.
//

import FBSDKCoreKit
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if let window = window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }
        
        if let shortcut = connectionOptions.shortcutItem {
            self.windowScene(windowScene, performActionFor: shortcut, completionHandler: { result in })
        }
        
        if let _ = connectionOptions.urlContexts.first?.url {
            self.scene(windowScene, openURLContexts: connectionOptions.urlContexts)
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        print(shortcutItem.type)
        appCoordinator?.showScreen(shortcutItem.type)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url, let name = url.host {
            ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil,
                                                   annotation:[UIApplication.OpenURLOptionsKey.annotation])
            appCoordinator?.showScreen(name)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

