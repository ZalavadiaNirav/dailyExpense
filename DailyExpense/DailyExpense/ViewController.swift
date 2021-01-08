//
//  ViewController.swift
//  DailyExpense
//
//  Created by Nirav  on 08/01/21.
//

import UIKit

class ExpenseListVC: UIViewController {

    @IBOutlet weak var expenseList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.title = "Daily Expense List"
        
        let rightBtn = UIBarButtonItem.init(title: "+", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addExpenseAction))
        
        self.navigationController?.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    @objc func addExpenseAction()
    {
        
    }


}

extension ExpenseListVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        return UITableViewCell.init()
    }
    
    
}

