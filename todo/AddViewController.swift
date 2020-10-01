//
//  AddViewController.swift
//  todo
//
//  Created by Yuuka Watanabe on 2020/09/29.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var duedateTextField: UITextField!
    @IBOutlet var contentTextField: UITextField!
    var realm: Realm!
    
    var toolBar:UIToolbar!
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        realm = try! Realm()
        duedateTextField.delegate = self
    }
    
    func setupToolbar() {
            //datepicker上のtoolbarのdoneボタン
            toolBar = UIToolbar()
            toolBar.sizeToFit()
            let toolBarBtn = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(doneBtn))
            toolBar.items = [toolBarBtn]
            duedateTextField.inputAccessoryView = toolBar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }

        //datepickerが選択されたらtextfieldに表示
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd"
        
        date = sender.date
        duedateTextField.text = dateFormatter.string(from: sender.date)
    }

    //toolbarのdoneボタン
    @objc func doneBtn(){
        duedateTextField.resignFirstResponder()
    }

    
    @IBAction func save() {
        let todo = Todo()
            todo.duedate = date ?? Date()
            todo.content = contentTextField.text ?? "Undefined"
        
        try! realm.write {
            realm.add(todo)
        }
        
        self.navigationController?.popViewController(animated: true)

        }
    
    
    
}
