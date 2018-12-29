//
//  State.swift
//  TodoList
//
//  Created by David Albert on 12/23/18.
//  Copyright © 2018 David Albert. All rights reserved.
//

import Foundation
import os

import ReSwift

struct Persistence {
    private init() {}

    static func saveTodos(todos: [Todo]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        guard let data = try? encoder.encode(todos) else {
            os_log(.error, "Can't encode Todos")
            return
        }

        let url = fileURL()
        let path = url.path

        try! FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)

        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(atPath: path, contents: data)
        } else {
            try! data.write(to: url)
        }
    }

    static func loadTodos() -> [Todo] {
        guard let data = try? Data(contentsOf: fileURL()) else {
            os_log(.debug, "Can't read todos.json")
            return []
        }

        let decoder = JSONDecoder()

        guard let todos = try? decoder.decode([Todo].self, from: data) else {
            os_log(.error, "Can't decode contents of todos.json")
            return []
        }

        return todos
    }

    private static func fileURL() -> URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let file = dir.appendingPathComponent(Bundle.main.bundleIdentifier!).appendingPathComponent("todos.json")

        return file
    }
}

struct Todo: Codable {
    var text: String
    var id = UUID()
    var done = false

    init(text: String) {
        self.text = text
    }
}

enum Filter: Int {
    case all
    case incomplete
    case completed
}

struct State : StateType {
    var todos = [Todo]()
    var newTodo = ""
    var selectedRow = -1
    var filter = Filter.all

    var pendingTodos: [Todo] {
        return todos.filter { !$0.done }
    }

    var finishedTodos: [Todo] {
        return todos.filter { $0.done }
    }

    var filteredTodos: [Todo] {
        switch filter {
        case .all:
            return todos
        case .incomplete:
            return pendingTodos
        case .completed:
            return finishedTodos
        }
    }
}


struct AddTodo: Action {
    let text: String
}

struct RemoveTodo: Action {
    let id: UUID
}

struct UpdateNewTodo: Action {
    let text: String
}

struct ToggleDone: Action {
    let id: UUID
}

struct UpdateSelection: Action {
    let row: Int
}

struct UpdateFilter: Action {
    let filter: Filter
}

struct ClearCompleted: Action {}

func reducer(action: Action, state: State?) -> State {
    var state = state ?? State()

    switch action {
    case is ReSwiftInit:
        state.todos = Persistence.loadTodos()
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

        if state.selectedRow >= state.filteredTodos.count {
            state.selectedRow = state.filteredTodos.count - 1
        }
    case let action as UpdateSelection:
        state.selectedRow = action.row
    case let action as UpdateFilter:
        state.filter = action.filter
    case is ClearCompleted:
        state.todos = state.pendingTodos
    default:
        break
    }

    return state
}
