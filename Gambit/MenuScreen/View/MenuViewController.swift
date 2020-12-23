//
//  ViewController.swift
//  Gambit
//
//  Created by Муслим Курбанов on 22.12.2020.
//

import UIKit

protocol MenuProtocol: class {
    func applyData(model: [Menu])
    func failure(error: Error)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var searchResponse = [Menu]() {
        didSet {
            menuTableView.reloadData()
        }
    }
    
    private let cartManager = CartManager.shared
    var presenter: MenuPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MenuPresenter(view: self)

        menuTableView.delegate = self
        menuTableView.dataSource = self
        // Do any additional setup after loading the view.
    }


}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResponse.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        let item = searchResponse[indexPath.row]
        var count = cartManager.getDishCount(by: item.id) ?? 0

        cell.configurate(with: item, delegate: self)
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
}

extension MenuViewController: MenuProtocol {
    func applyData(model: [Menu]) {
        searchResponse.append(contentsOf: model)
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

extension MenuViewController: MenuTableViewCellDelegate {
    func orderAdded(_ order: Menu) {
        guard cartManager.dishesIds.count < 2 else { return }
    }
    
    func orderDeleted(_ order: Menu) {
        guard cartManager.dishesIds.count == 0 else { return }
    }
    
    
}
