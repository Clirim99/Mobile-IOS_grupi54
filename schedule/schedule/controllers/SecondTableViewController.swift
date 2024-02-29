//import UIKit
//
//
//
//class SecondTableController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
//
//    @IBOutlet var enterProdTextField2: UITextField!
//    @IBOutlet var priceTextField2: UITextField!
//    @IBOutlet var addButton2: UIButton!
//    @IBOutlet var tableView2: UITableView!
//    @IBOutlet var billsTotalTextField: UITextField!
//    @IBOutlet var calculateButton2: UIButton!
//    
//    var products: [Product] = []
//    
//    let numberFormatter: NumberFormatter = {
//          let formatter = NumberFormatter()
//          formatter.numberStyle = .currency
//          formatter.currencySymbol = "€"
//          formatter.minimumFractionDigits = 2
//          formatter.maximumFractionDigits = 2
//          return formatter
//      }()
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return products.count
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
//            let product = products[indexPath.row]
//            cell.lblName.text = product.name
//            cell.lblPrice.text = numberFormatter.string(from: NSNumber(value: product.price))
//
//            return cell
//        }
//
//    
//}
//
//class SecondTableViewCell: UITableViewCell {
//
//    @IBOutlet var lblName2: UILabel!
//    @IBOutlet var lblPrice2: UILabel!
//    @IBOutlet var deleteButton2: UIButton!
//    
//    var onDeleteButtonTapped: (() -> Void)?
//
//    @IBAction func deleteButtonTapped(_ sender: UIButton) {
//        onDeleteButtonTapped?()
//    }
//
//}
