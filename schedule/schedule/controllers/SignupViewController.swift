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
    @IBOutlet var passwordMinimumLengthWarning: UILabel!
    
    @IBOutlet weak var passwordsMustMatch: UILabel!
    
    @IBOutlet weak var emailSuffix: UILabel!
    
    @IBOutlet weak var firstNameRequired: UILabel!
    
    @IBOutlet weak var lastNameRequired: UILabel!
    
    @IBOutlet weak var userNameRequired: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        passwordMinimumLengthWarning.isHidden = true
        passwordsMustMatch.isHidden = true
        emailSuffix.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
        
        guard let firstName = first_name.text, !firstName.isEmpty else {
                    
                    print("All fields are required")
                firstNameRequired.text = "firstname is required"
            firstNameRequired.isHidden = false
            
                    return
                }
        guard let lastName = last_name.text, !lastName.isEmpty else{
            
            print("All fields are required")
            lastNameRequired.text = "lastname is required"
            lastNameRequired.isHidden = false
            return
            
        }
        guard let emailText = email.text, !emailText.isEmpty else{
            
            print("All fields are required")
            emailSuffix.text = "email is required"
            emailSuffix.isHidden = false

            return
            
        }
        guard let usernameText = username.text, !usernameText.isEmpty else{
            
            print("All fields are required")
            userNameRequired.text = "username is required"
            userNameRequired.isHidden = false
            return
            
        }
        guard let passwordText = password.text, !passwordText.isEmpty else{
            
            print("All fields are required")
            passwordsMustMatch.text = "confirmpassword is required"
            passwordsMustMatch.isHidden = false
            return
            
        }
        guard let confirmpasswordText = cofirmpassword.text, !confirmpasswordText.isEmpty else{
            
            print("All fields are required")
            passwordMinimumLengthWarning.text = "password is required"
            passwordMinimumLengthWarning.isHidden = false
            return
            
        }
            // Validate password and confirm password
        guard let password = password.text, let confirmPassword = cofirmpassword.text, password == confirmPassword else {
            // Handle password mismatch error
            print("Password and confirm password mismatch")
            return
        }
        
       
        
        
        guard password == confirmPassword else {
                   // Handle password mismatch error
                   print("Password and confirm password mismatch")
            passwordsMustMatch.text = "Password and confirm password mismatch"
            passwordsMustMatch.isHidden = false
               // passwordMinimumLengthWarning.text = "password doesnt not match"

                   return
        }
               
        guard password.count > 8 else {
                   // Handle password length error
        print("Password must be more than 8 characters")
            passwordMinimumLengthWarning.text = "Password must be more than 8 characters"
            passwordMinimumLengthWarning.isHidden = false
            
        return
               }
        
        guard let emailText = email.text, emailText.hasSuffix("@gmail.com") else {
                   // Handle invalid email error
                   print("Email must end with @gmail.com")
            emailSuffix.text = "Email must end with @gmail.com"
                   return
            emailSuffix.isHidden = false
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
