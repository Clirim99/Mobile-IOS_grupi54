//
//  SpendingsViewController.swift
//  schedule
//
//  Created by user257547 on 2/28/24.
//

import UIKit
import CoreData

class SpendingsViewController: UIViewController {
    @IBOutlet var enterTotalTextField: UITextField!
    @IBOutlet var calculateButton: UIButton!
    var activeUser:User = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        activeUser = fetchUser()?.user_id ?? User()
        enterTotalTextField.text = String(format: "%.2f", getTotalCostForUser(user: activeUser))
        

        
    }
    
    @IBAction func calculatebuttonAction(_ sender: Any) {
        enterTotalTextField.text = String(format: "%.2f", getTotalCostForUser(user: activeUser))
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
    func getTotalCostForUser(user: User) -> Double {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return 0
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Spending> = Spending.fetchRequest()
        
        // Filter spendings by the user
        fetchRequest.predicate = NSPredicate(format: "buyer == %@", user)
        
        do {
            let spendings = try context.fetch(fetchRequest)
            let totalCost = spendings.reduce(0.0) { $0 + ($1.cost ) }
            return totalCost
        } catch {
            print("Failed to fetch spendings: \(error)")
            return 0
        }
    }
    func fetchUser() -> ActiveUser? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ActiveUser> = ActiveUser.fetchRequest() // Adjust the fetch request type to ActiveUser
        
        do {
            // Fetch only the first user, assuming you want only one user
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }

}
