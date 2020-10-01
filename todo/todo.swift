//
//  todo.swift
//  todo
//
//  Created by Yuuka Watanabe on 2020/09/29.
//

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var duedate: Date!
    @objc dynamic var content = ""
    @objc dynamic var done = false
}
