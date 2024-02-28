import UIKit
import CoreData

class LoginViewController: UIViewController {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: UIButton) {
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
                // Optionally, you can perform a segue or navigate to another screen upon successful login
            } else {
                print("Invalid username or password")
                // Optionally, you can display an alert indicating login failure
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }

    // ... Additional code for navigation, etc.

}
