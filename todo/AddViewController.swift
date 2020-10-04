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
        //　通知設定に必要なクラスをインスタンス化
        let trigger: UNNotificationTrigger
        let content = UNMutableNotificationContent()
        var notificationTime = DateComponents()
        
        // トリガー設定
        let calendar = Calendar.current
        notificationTime.year = calendar.component(.year, from: date ?? Date())
        notificationTime.month = calendar.component(.month, from: date ?? Date())
        notificationTime.day = calendar.component(.day, from: date ?? Date())
        notificationTime.hour = 9
        notificationTime.minute = 0
        notificationTime.second = 0
        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
        
        // 通知内容の設定
        content.title = ""
        content.body = "リマインダー"
        content.sound = UNNotificationSound.default
        
        // 通知スタイルを指定
        let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        let todo = Todo()
        todo.duedate = date ?? Date()
        todo.content = contentTextField.text ?? "Undefined"
        
        try! realm.write {
            realm.add(todo)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}
