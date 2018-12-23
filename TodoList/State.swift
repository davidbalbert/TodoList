//
//  State.swift
//  TodoList
//
//  Created by David Albert on 12/23/18.
//  Copyright © 2018 David Albert. All rights reserved.
//

import Foundation

struct Todo {
    var text = ""
    var done = false
}

struct State {
    var todos = [Todo]()
}
