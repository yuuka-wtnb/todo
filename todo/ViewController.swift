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
    var realm: Realm!

    var dos: Results<Todo>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // TableViewの初期化
        table.delegate = self
        table.dataSource = self

        // Realmの初期化
        realm = try! Realm()

        dos = realm.objects(Todo.self)
        table.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dos = realm.objects(Todo.self)
        table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd"
        cell.textLabel?.text = dos[indexPath.row].content + " - " +  dateFormatter.string(from: dos[indexPath.row].duedate)
        return cell
    }
}

