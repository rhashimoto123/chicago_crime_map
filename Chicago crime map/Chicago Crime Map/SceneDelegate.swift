//
//  SceneDelegate.swift
//  Chicago crime map
//
//  Created by Ryoya Hashimoto on 2/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var launchFromTerminated = true
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
        let initialDate = UserDefaults.standard.object(forKey: "Initial Launch") as! Date
        if initialDate == nil {
            print("DEBUG ----> Showing an Instruction")
            if launchFromTerminated {
              showSplashScreen(autoDismiss: false, label: "Splash")
              launchFromTerminated = false
            }
        }
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
  
  /// Load the SplashViewController from Splash.storyboard
  func showSplashScreen(autoDismiss: Bool, label: String) {
    let storyboard = UIStoryboard(name: "Splash", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
    
    // Control the behavior from suspended to launch
    controller.modalPresentationStyle = .fullScreen
    
    // Present the view controller over the top view controller
    let vc = topController()
    vc.present(controller, animated: false, completion: nil)
  }
  
  
  /// Determine the top view controller on the screen
  /// - Returns: UIViewController
  func topController(_ parent:UIViewController? = nil) -> UIViewController {
    if let vc = parent {
      if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
        return topController(selected)
      } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
        return topController(top)
      } else if let presented = vc.presentedViewController {
        return topController(presented)
      } else {
        return vc
      }
    } else {
      return topController(UIApplication.shared.keyWindow!.rootViewController!)
    }
  }
}


