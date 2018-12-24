//
//  ViewController.swift
//  TodoList
//
//  Created by David Albert on 12/23/18.
//  Copyright © 2018 David Albert. All rights reserved.
//

import Cocoa
import ReSwift

class ViewController: NSViewController, StoreSubscriber, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate, TodoTableViewDelegate {
    typealias StoreSubscriberStateType = State

    @IBOutlet var textField: NSTextField!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var addButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        mainStore.subscribe(self)
        view.window?.makeFirstResponder(textField)
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()

        mainStore.unsubscribe(self)
    }

    func newState(state: State) {
        tableView.reloadData()
        addButton.isEnabled = !state.newTodo.isEmpty
        textField.stringValue = state.newTodo
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return mainStore.state.todos.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < mainStore.state.todos.count else {
            return nil
        }

        let todo = mainStore.state.todos[row]

        switch tableColumn!.identifier.rawValue {
        case "DoneColumn":
            let view = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: nil) as! CheckboxTableCellView
            view.checkbox.state = todo.done ? .on : .off
            return view
        case "TitleColumn":
            let view = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: nil) as! NSTableCellView


            let s = NSMutableAttributedString(string: todo.text)

            if todo.done {
                s.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, s.length))
            }

            view.textField?.attributedStringValue = s
            return view
        default:
            NSLog("Unknown column identifier \(tableColumn!.identifier.rawValue)")
            return nil
        }
    }

    func id(forRow row: Int) -> UUID {
        return mainStore.state.todos[row].id
    }

    func deleteKeyPressed(_ tableView: TodoTableView, forRow row: Int) {
        if row >= 0 {
            mainStore.dispatch(
                RemoveTodo(id: id(forRow: row))
            )
        }
    }

    @IBAction func addButtonClicked(_ sender: NSButton) {
        mainStore.dispatch(
            AddTodo(text: mainStore.state.newTodo)
        )
    }

    @IBAction func doneButtonClicked(_ sender: NSButton) {
        let row = tableView.row(for: sender)

        mainStore.dispatch(
            ToggleDone(id: id(forRow: row))
        )
    }

    func controlTextDidChange(_ obj: Notification) {
        mainStore.dispatch(
            UpdateNewTodo(text: (obj.object as! NSTextField).stringValue)
        )
    }
}

