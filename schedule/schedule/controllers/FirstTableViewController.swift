import UIKit

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
        tableView.dataSource = self
        tableView.delegate = self
        priceTextField.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        print("Add button tapped")
        guard let productName = enterProdTextField.text,
              let priceString = priceTextField.text,
              !productName.isEmpty,
              !priceString.isEmpty else {
            let alert = UIAlertController(title: "Missing Information", message: "Please fill in both fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
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
