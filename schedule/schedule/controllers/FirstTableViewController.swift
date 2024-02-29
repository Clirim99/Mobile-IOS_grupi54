import UIKit
import CoreData

struct Product {
    let name: String
    let price: Double
}

class FirstTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var enterProdTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var foodTotalTextField: UITextField!
    @IBOutlet var calculateButton: UIButton!
    
    var products: [Product] = []
    var prodsFromDb : [Spending] = []
    var activeUser:User = User()
    var parameter: String = "Food"
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeUser = fetchUser()?.user_id ?? User()
        self.prodsFromDb = fetchProductsFilteredByTypeAndUser()

        for prod in prodsFromDb {
            products.append(Product(name:prod.product_name ?? "", price: prod.cost))
        }
        tableView.dataSource = self
        tableView.delegate = self
        priceTextField.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        print("Add button tapped")
        guard let productName = enterProdTextField.text,
              let priceString = priceTextField.text,
              let price = Double(priceString),
              !productName.isEmpty,
              !priceString.isEmpty else {
            let alert = UIAlertController(title: "Missing Information", message: "Please fill in both fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Insert the product into CoreData
        insertProductIntoCoreData(name: productName, price: price, productType: parameter, user: activeUser)
          
        // Remove non-numeric characters and the euro sign from the price string
        let cleanPriceString = priceString
            .replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        
        // Convert the cleaned price string to a Double
        guard let price = Double(cleanPriceString) else {
            let alert = UIAlertController(title: "Invalid Price", message: "Please enter a valid price.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let newProduct = Product(name: productName, price: price)
        products.append(newProduct)
        
        enterProdTextField.text = ""
        priceTextField.text = ""
        
        tableView.reloadData()
    }
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
            let total = products.reduce(0.0) { $0 + $1.price }
            foodTotalTextField.text = numberFormatter.string(from: NSNumber(value: total))
        }
    

    // Inserting a product into CoreData
    func insertProductIntoCoreData(name: String, price: Double, productType: String, user:User) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a new Spending object
        if let newSpending = NSEntityDescription.insertNewObject(forEntityName: "Spending", into: context) as? Spending {
            newSpending.id = UUID()
            newSpending.cost = price
            newSpending.product_name = name
            newSpending.buyer = user
            // Fetch the ProductType object
            let fetchRequest: NSFetchRequest<ProductType> = ProductType.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "type_name == %@", productType)
            
            do {
                let productTypes = try context.fetch(fetchRequest)
                if let productType = productTypes.first {
                    newSpending.product_type = productType
                } else {
                    // If the ProductType doesn't exist, you may want to handle this case appropriately
                    print("ProductType '\(productType)' does not exist")
                }
            } catch {
                print("Failed to fetch product type: \(error)")
            }
            
            // Save the context
            do {
                try context.save()
                self.prodsFromDb.append(newSpending)
            } catch {
                print("Failed to save product: \(error)")
            }
        }
    }
    
    //Delete spending product from db
    func deleteSpendingByID(id: UUID) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("Unable to access app delegate")
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<Spending> = Spending.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let spendings = try context.fetch(fetchRequest)
                if let spendingToDelete = spendings.first {
                    context.delete(spendingToDelete)
                    try context.save()
                    print("Spending with ID \(id) deleted successfully")
                } else {
                    print("No spending found with ID \(id)")
                }
            } catch {
                print("Failed to delete spending: \(error)")
            }
        }

    // Fetching products filtered by product type
    func fetchProductsFilteredByTypeAndUser() -> [Spending] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Spending> = Spending.fetchRequest()
        
        // Assuming you have relationships between Spending, ProductType, and User
        let predicate = NSPredicate(format: "product_type.type_name == %@ AND buyer == %@", parameter, activeUser)
        fetchRequest.predicate = predicate
        
        do {
            let products = try context.fetch(fetchRequest)
            return products
        } catch {
            print("Failed to fetch products: \(error)")
            return []
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


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let product = products[indexPath.row]
        cell.lblName.text = product.name
        cell.lblPrice.text = numberFormatter.string(from: NSNumber(value: product.price))
        
        cell.onDeleteButtonTapped = { [weak self] in
            self?.products.remove(at: indexPath.row)
            tableView.reloadData()
            guard let spendingToDelete = self?.prodsFromDb[indexPath.row] else {
                    print("Invalid index or spending not found")
                    return
                }
               // Delete the spending from CoreData using its ID
            let spendingID = spendingToDelete.id

            self?.deleteSpendingByID(id: spendingID ?? UUID())
        
        }

        return cell
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == priceTextField {
            let invalidCharacters = CharacterSet(charactersIn: "0123456789,.").inverted
            if let _ = string.rangeOfCharacter(from: invalidCharacters) {
                let alert = UIAlertController(title: "Invalid Input", message: "Please enter a valid number.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}

class CustomTableViewCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var deleteButton: UIButton! 

    var onDeleteButtonTapped: (() -> Void)?

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        onDeleteButtonTapped?()
    }
}
