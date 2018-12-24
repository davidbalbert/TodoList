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
    var text: String
    var id = UUID()
    var done = false

    init(text: String) {
        self.text = text
    }
}

struct State : StateType {
    var todos = [Todo]()
    var newTodo = ""
}


struct AddTodo : Action {
    let text: String
}

struct RemoveTodo : Action {
    let id: UUID
}

struct UpdateNewTodo : Action {
    let text: String
}

struct ToggleDone : Action {
    let id: UUID
}

func reducer(action: Action, state: State?) -> State {
    var state = state ?? State()

    switch action {
    case let action as AddTodo:
        state.todos.append(Todo(text: action.text))
        state.newTodo = ""
    case let action as UpdateNewTodo:
        state.newTodo = action.text
    case let action as ToggleDone:
        guard let idx = state.todos.index(where: { $0.id == action.id }) else {
            NSLog("Can't find todo with id \(action.id)")
            break
        }

        state.todos[idx].done = !state.todos[idx].done
    case let action as RemoveTodo:
        state.todos = state.todos.filter { $0.id != action.id }
    default:
        break
    }

    return state
}
