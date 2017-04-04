//
//  ViewController.swift
//  coredataInit
//
//  Created by Usuário Convidado on 03/04/17.
//  Copyright © 2017 roberto. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfDetail: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    
    var list = [Task]()
    var datePicker = UIDatePicker()
    let df = DateFormatter()
    let locale = Locale(identifier: "pt-BR")
     var toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        df.dateStyle = .short
        df.locale = locale
        datePicker.locale = locale
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btOk = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        toolbar.items = [btCancel, btSpace, btOk]
        
        tfDate.inputView = datePicker
        tfDate.inputAccessoryView = toolbar
        
        loadTasks()
    }
    
    func cancel() {
        tfDate.resignFirstResponder()
    }
    
    func done() {
        tfDate.text = df.string(from: datePicker.date)
        cancel()
    }
    
    func delete(indexPath: IndexPath) {
        
        let task = list[indexPath.row] as Task
        self.context.delete(task)
        try! self.context.save()
        
        list.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }

    func loadTasks() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            try list = context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            
        }
    }
    
    func showEditAlert(task: Task) {
        let alert = UIAlertController(title: "Editar", message: "Editar tarefa", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = task.title
        }
        
        alert.addTextField { (textField) in
            textField.text = task.detail
        }
        
        alert.addTextField { (textField) in
            textField.text = self.df.string(from: task.date as! Date)
            textField.inputView = self.datePicker
            textField.inputAccessoryView = self.toolbar
        }
        
        let okAction = UIAlertAction(title: "Salvar", style: .default) { (action) in
            
            task.title = alert.textFields![0].text
            task.detail = alert.textFields![1].text
            task.date = self.datePicker.date as NSDate?
            
            do {
                try self.context.save()
                
                self.tfDetail.text = ""
                self.tfTitle.text = ""
                self.tfDate.text = ""
                
                self.loadTasks()
            } catch {
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        let task = Task(context: context)
        task.title = tfTitle.text
        task.detail = tfDetail.text
        task.date = datePicker.date as NSDate?
        
        do {
            try context.save()
            self.loadTasks()
        } catch {
            
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Deletar") { (action, indexPath) in
            self.delete(indexPath: indexPath)
        }
        
        let editAction = UITableViewRowAction(style: .default, title: "Editar") { (action, indexPath) in
            self.showEditAlert(task: self.list[indexPath.row])
        }
        
        return [deleteAction, editAction]
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = list[indexPath.row]
        cell.textLabel?.text = task.title!
        cell.detailTextLabel?.text = df.string(from: task.date as! Date)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return cell
    }
}
