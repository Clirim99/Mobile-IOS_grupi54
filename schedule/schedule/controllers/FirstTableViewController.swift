//import UIKit
//
//struct Product {
//    let name: String
//    let price: String
//}
//
//class FirstTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    @IBOutlet var enterProdTextField: UITextField!
//    @IBOutlet var priceTextField: UITextField!
//    @IBOutlet var addButton: UIButton!
//    @IBOutlet var tableView: UITableView!
//    
////    var products: [Product] = []
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        tableView.dataSource = self
////        tableView.delegate = self
////        
////        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")    }
////    
////    @IBAction func addButtonTapped(_ sender: UIButton) {
////        print("Add button tapped")
////        guard let productName = enterProdTextField.text, let price = priceTextField.text else {
////            return
////        }
////        
////        let newProduct = Product(name: productName, price: price)
////        products.append(newProduct)
////        
////        enterProdTextField.text = ""
////        priceTextField.text = ""
////        
////        // Check if tableView is not nil before reloading data
////        if let tableView = tableView {
////            tableView.reloadData()
////        }
////    }
////    
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return products.count
////    }
////    
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
////        let product = products[indexPath.row]
////        cell.lblName?.text = product.name
////        cell.lblPrice?.text = product.price
////        return cell
////    }
//}
