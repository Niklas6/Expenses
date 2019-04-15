//
//  ExpensesViewController.swift
//  Expenses
//
//  Created by Tech Innovator on 11/30/17.
//  Copyright © 2017 Tech Innovator. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController {
    
    @IBOutlet weak var expensesTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    
    var expenses = [Expense]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
        
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            expenses = try managedContext.fetch(fetchRequest)

            expensesTableView.reloadData()
        } catch{
            print("Fetch could not be preformed")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewExpense(_ sender: Any) {
        performSegue(withIdentifier: "ShowExpense", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SingleExpenseViewController,
            let selectedRow = self.expensesTableView.indexPathForSelectedRow?.row else {
                return
        }
        destination.existingExpense = expenses[selectedRow]
    }
    func deleteExpense(at indexPath: IndexPath) {
        let expense = expenses[indexPath.row]
        
        let managedContext = expense.managedObjectContext {
            managedContext.delete(expense)
            
            do {
                try managedContext.save()
                
                self.expenses.remove(at: indexPath.row)
                
                expensesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("delete failed")
            }
        }
    }
}

extension ExpensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expensesTableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        let expense = expenses[indexPath.row]
        
        cell.textLabel?.text = expense.name
        
        if let date = expense.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
}

extension ExpensesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showExpense", sender: self)
        
    }
}
