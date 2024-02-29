//
//  SpendingsViewController.swift
//  schedule
//
//  Created by user257547 on 2/28/24.
//

import UIKit
import CoreData

class SpendingsViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func foodbuttonAction(_ sender: Any) {
        // Call the function when the "Food" button is pressed
        navigateToFirstTableViewController(parameter:"Food")
    }
    
    @IBAction func billsbuttonAction(_ sender: Any) {
        // Call the function when the "Bills" button is pressed
        navigateToFirstTableViewController(parameter:"Bills")
    }
    
    @IBAction func transportbuttonAction(_ sender: Any) {
        // Call the function when the "Transport" button is pressed
        navigateToFirstTableViewController(parameter:"Transport")
    }
    
    @IBAction func othersbuttonAction(_ sender: Any) {
        // Call the function when the "Others" button is pressed
        navigateToFirstTableViewController(parameter:"Others")
    }

    func navigateToFirstTableViewController(parameter:String) {
        // Ensure the current view controller is embedded in a navigation controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "FirstTableViewController") as? FirstTableViewController {
            destinationViewController.parameter = parameter
            print("Successfully instantiated FirstTableViewController")
            
            // Perform the navigation
            navigationController?.pushViewController(destinationViewController, animated: true)
        } else {
            print("Failed to instantiate FirstTableViewController")
        }
    }
    
    @IBAction func signoutButtonAction(_ sender: Any) {
        // Call the function when the "Food" button is pressed
        navigateToFirstViewController()
    }

    func navigateToFirstViewController() {
        // Ensure the current view controller is embedded in a navigation controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController {
            deleteAllActiveUsers()
            print("Successfully instantiated FirstViewController")
            
            // Perform the navigation
            navigationController?.pushViewController(destinationViewController, animated: true)
        } else {
            print("Failed to instantiate FirstViewController")
        }
    }
    
    func deleteAllActiveUsers() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to access app delegate")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ActiveUser")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("All active users deleted successfully")
        } catch {
            print("Failed to delete active users: \(error)")
        }
    }


}
