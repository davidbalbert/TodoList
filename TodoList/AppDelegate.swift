//
//  AppDelegate.swift
//  TodoList
//
//  Created by David Albert on 12/23/18.
//  Copyright © 2018 David Albert. All rights reserved.
//

import Cocoa

var state = State(todos: [
    Todo(text: "Thing one", done: false),
    Todo(text: "Thing two", done: false),
    Todo(text: "Thing three", done: false),
])

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

