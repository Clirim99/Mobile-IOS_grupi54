//
//  SignupViewController.swift
//  schedule
//
//  Created by user257547 on 2/27/24.
//

import UIKit
import CoreData

class SignupViewController: UIViewController {
    @IBOutlet var first_name:UITextField!
    @IBOutlet var last_name:UITextField!
    @IBOutlet var email:UITextField!
    @IBOutlet var username:UITextField!
    @IBOutlet var password:UITextField!
    @IBOutlet var cofirmpassword:UITextField!
    @IBOutlet var signupButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            
            // Validate password and confirm password
        guard let password = password.text, let confirmPassword = cofirmpassword.text, password == confirmPassword else {
            // Handle password mismatch error
            print("Password and confirm password mismatch")
            return
        }
            
            // Create a new User managed object
        if let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context),
           let newUser = NSManagedObject(entity: userEntity, insertInto: context) as? User {
                
            // Set user properties
            newUser.email = email.text
            newUser.first_name = first_name.text
            newUser.last_name = last_name.text
            newUser.password = password // Assuming password is a UITextField
            newUser.username = username.text
            
            // Save the user object to Core Data
            do {
                try context.save()
                navigateToLoginViewController()
                print("User saved successfully")
                fetchUsers()
                // Optionally, you can show an alert or navigate to another screen upon successful signup
            } catch {
                print("Failed to save user: \(error.localizedDescription)")
            }
        } else {
            print("Failed to create user entity")
        }
        }
    
    
    func fetchUsers() {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               return
           }

           let context = appDelegate.persistentContainer.viewContext

           // Create a fetch request for the User entity
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

           do {
               // Execute the fetch request
               let users = try context.fetch(fetchRequest)

               // Print the fetched users
               if let users = users as? [User] {
                   print("Fetched Users:")
                   for user in users {
                       print("Username: \(user.username ?? "N/A"), Email: \(user.email ?? "N/A")")
                       // Print other user properties as needed
                   }
               }
           } catch {
               print("Failed to fetch users: \(error.localizedDescription)")
           }
       }
            
          
    func navigateToLoginViewController() {
          
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            
            print("Successfully instantiated LoginViewController")
            
            // Perform the navigation
            navigationController?.pushViewController(destinationViewController, animated: true)
        } else {
            print("Failed to instantiate LoginViewController")
        }
    }
        
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
