//
// AppDelegate.swift
// schedule
//
// Created by user257547 on 2/26/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        insertProductTypesIfNeeded()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func insertProductTypesIfNeeded() {
        let hasInsertedTypes = UserDefaults.standard.bool(forKey: "hasInsertedProductTypes")
        guard !hasInsertedTypes else {
            print("Product types have already been inserted.")
            return
        }
        
        let context = persistentContainer.viewContext
        
        let productTypeNames = ["Food", "Bills", "Transport", "Others"]
        
        for typeName in productTypeNames {
            // Check if the ProductType already exists
            let fetchRequest: NSFetchRequest<ProductType> = ProductType.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "type_name == %@", typeName)
            
            do {
                let existingTypes = try context.fetch(fetchRequest)
                if existingTypes.isEmpty {
                    // Create a new ProductType object
                    let newProductType = ProductType(context: context)
                    newProductType.id = UUID()
                    newProductType.type_name = typeName
                    
                    do {
                        try context.save()
                        print("ProductType '\(typeName)' inserted successfully.")
                    } catch {
                        print("Failed to save ProductType: \(error.localizedDescription)")
                    }
                } else {
                    print("ProductType '\(typeName)' already exists.")
                }
            } catch {
                print("Failed to fetch existing ProductTypes: \(error.localizedDescription)")
            }
        }
        
        // Set the flag to indicate that types have been inserted
        UserDefaults.standard.set(true, forKey: "hasInsertedProductTypes")
        print("Product types inserted. Flag set.")
    }

}
