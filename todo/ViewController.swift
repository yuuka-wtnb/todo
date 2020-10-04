//
//  ViewController.swift
//  todo
//
//  Created by Yuuka Watanabe on 2020/09/29.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    @IBOutlet var difficultyLabel: UILabel!
    
    var realm: Realm!
    
    var todos: Results<Todo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // TableViewの初期化
        table.delegate = self
        table.dataSource = self
        
        // Realmの初期化
        realm = try! Realm()
        
        todos = realm.objects(Todo.self)
        table.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        todos = realm.objects(Todo.self)
        table.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if todos.count <= 3 {
            difficultyLabel.text = "あ"
        }else if todos.count <= 5{
            difficultyLabel.text = "い"
        }else{
            difficultyLabel.text = "う"
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd"
        cell.textLabel?.text = todos[indexPath.row].content + " - " +  dateFormatter.string(from: todos[indexPath.row].duedate)
        
        if todos[indexPath.row].done {
            cell.accessoryType = .checkmark
            cell.backgroundColor = .orange
        } else {
            cell.accessoryType = .none
            cell.backgroundColor = .white
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        try! realm.write {
            todos[indexPath.row].done = !todos[indexPath.row].done
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        try! realm.write {
            realm.delete(todos[indexPath.row])
        }

        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

