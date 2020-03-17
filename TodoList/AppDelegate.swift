//
//  AppDelegate.swift
//  TodoList
//
//  Created by Khadija Daruwala on 12/03/20.
//  Copyright © 2020 Khadija Daruwala. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        do {
            _ = try Realm()
        } catch {
            print("Error while initialising realm \(error)")
        }
        
        return true
    }
}
