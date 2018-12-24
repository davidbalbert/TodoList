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
    var newTodo = ""
}


struct AddTodo : Action {
    let text: String
}

struct RemoveTodo : Action {
    let todo: Int
}

struct UpdateNewTodo : Action {
    let text: String
}

struct ToggleDone : Action {
    let todo: Int
}

func reducer(action: Action, state: State?) -> State {
    var state = state ?? State()

    switch action {
    case let action as AddTodo:
        state.todos.append(Todo(text: action.text, done: false))
        state.newTodo = ""
    case let action as UpdateNewTodo:
        state.newTodo = action.text
    case let action as ToggleDone:
        state.todos[action.todo].done = !state.todos[action.todo].done
    case let action as RemoveTodo:
        let todo = action.todo

        state.todos = Array(state.todos[..<todo]) + Array(state.todos[(todo+1)...])
    default:
        break
    }

    return state
}
