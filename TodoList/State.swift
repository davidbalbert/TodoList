//
//  State.swift
//  TodoList
//
//  Created by David Albert on 12/23/18.
//  Copyright © 2018 David Albert. All rights reserved.
//

import Foundation
import ReSwift

struct Todo {
    var text = ""
    var done = false
}

struct State : StateType {
    var todos = [Todo]()
}

struct AddTodo : Action {
    let text: String
}

func reducer(action: Action, state: State?) -> State {
    var state = state ?? State()

    switch action {
    case let action as AddTodo:
        state.todos.append(Todo(text: action.text, done: false))
    default:
        break
    }

    return state
}
