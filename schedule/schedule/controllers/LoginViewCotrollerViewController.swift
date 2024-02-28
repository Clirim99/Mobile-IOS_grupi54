

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

   
        @IBAction func loginAction(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            print("Invalid username or password")
            return
        }

        // Create a fetch request for the User entity with a predicate to match the username and password
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

        do {
            let users = try context.fetch(fetchRequest)

            if let matchedUser = users.first as? User {
                print("Login successful! Welcome, \(matchedUser.username!)")
                navigateToSpendingsViewController()
                // Optionally, you can perform a segue or navigate to another screen upon successful login
            } else {
                print("Invalid username or password")
                // Optionally, you can display an alert indicating login failure
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }
    func navigateToSpendingsViewController() {
            // Get reference to the storyboard
//            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your actual storyboard name
//
//            // Instantiate SpendingsViewController from the storyboard
//            if let spendingsViewController = storyboard.instantiateViewController(withIdentifier: "SpendingsViewController") as? SpendingsViewController {
//                
//                // Perform the navigation
//                navigationController?.pushViewController(spendingsViewController, animated: true)
                
//                let destinationViewController = SpendingsViewController ()
//                navigationController?.pushViewController(destinationViewController, animated: true)

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SpendingsViewController") as? SpendingsViewController {
            
            print("Successfully instantiated SpendingsViewController")
            
            // Perform the navigation
            navigationController?.pushViewController(destinationViewController, animated: true)
        } else {
            print("Failed to instantiate SpendingsViewController")
        }
            }
        

    // ... Additional code for navigation, etc.

}
