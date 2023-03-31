//
//  ProductViewController.swift
//  mobile details
//
//  Created by Kushal Rana on 30/03/23.
//

import UIKit
import Kingfisher

class ProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var productTableView: UITableView!
    
    var productModelArray = ProductModel(products: []) // aaray initialization
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTheJsonData()
        //getDatafromAPI()
        
        
        productTableView.delegate = self
        productTableView.dataSource = self
    }
    
  
    // UItableView Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productModelArray.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell

     //optional binding
        
        
        if let title =  productModelArray.products[indexPath.row].title , let brand = productModelArray.products[indexPath.row].brand {
            cell.deviceTitleLabel.text = title + " | " + brand
        }
        

        if let price = productModelArray.products[indexPath.row].price {
            cell.priceLabel.text = "₹ " + String(price)
        }
        
        if let descriptionLabel = productModelArray.products[indexPath.row].description {
            cell.descriptionLabel.text = descriptionLabel
        }
        
        if let discount = productModelArray.products[indexPath.row].discountPercentage {
            let str = String(format: "%.3f", Double(discount))
            cell.brandLabel.text = "discount - " + str + "%"
        }
        
        if let thumbnilUrl = productModelArray.products[indexPath.row].thumbnail {
            cell.productImageView.kf.setImage(with: URL(string: thumbnilUrl ))
            cell.productImageView.kf.indicatorType = .activity
        }

        return cell
    }
    
    // delegate method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Index: \(indexPath.row)")
    }
    
    
    
    
    // get data from url using URLSession
    
    func getDatafromAPI() {
        URLSession.shared.fetchData(for: URL_PRODUCT ) { ( result: Result<ProductModel , Error>) in
            switch result {
            case.success(let jsonObject):
                self.productModelArray.products = jsonObject.products
                DispatchQueue.main.async {
                    self.productTableView.reloadData()
                }
                break
            case . failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    // get data from bundle file
    func getTheJsonData() {
        let model = readJSONFromFile(fileName: "ProductJson", type: ProductModel.self)
        
        if let products = model {
            productModelArray = products
            print(productModelArray)
            //productTableView.reloadData()
        }
    }
    
    
    func readJSONFromFile<T: Decodable>(fileName: String, type: T.Type) -> T?
    {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
}


