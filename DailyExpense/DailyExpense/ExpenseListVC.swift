//
//  ViewController.swift
//  DailyExpense
//
//  Created by Nirav  on 08/01/21.
//

import UIKit


class ExpenseListVC: UIViewController {

    private let cellIdentifier = "cell"
    
    @IBOutlet weak var expenseList: UITableView!
    
    
    var expenses: [ExpenseModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Daily Expense List"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        expenses = DBManager.shared.loadExpense()
        expenseList.reloadData()
    }
}

extension ExpenseListVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (expenses != nil) ? expenses.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        let currentExpense = expenses[indexPath.row]
        
        cell.textLabel?.text = currentExpense.title
    
        return cell
    
    }
}

