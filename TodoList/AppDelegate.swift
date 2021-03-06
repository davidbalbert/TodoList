//
//  AppDelegate.swift
//  TodoList
//
//  Created by David Albert on 12/23/18.
//  Copyright © 2018 David Albert. All rights reserved.
//

import Cocoa
import ReSwift

let thunksMiddleware: Middleware<State> = createThunksMiddleware()

let mainStore = Store<State>(
    reducer: reducer,
    state: nil,
    middleware: [thunksMiddleware]
)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        Persistence.saveTodos(todos: mainStore.state.todos)
    }
}

