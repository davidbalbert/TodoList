//
//  ViewController.swift
//  TodoList
//
//  Created by David Albert on 12/23/18.
//  Copyright © 2018 David Albert. All rights reserved.
//

import Cocoa
import ReSwift

class ViewController: NSViewController, StoreSubscriber, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {
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

        if let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = mainStore.state.todos[row].text

            return cell
        }
        
        return nil
    }

    @IBAction func addButtonClicked(_ sender: NSButton) {
        mainStore.dispatch(
            AddTodo(text: mainStore.state.newTodo)
        )
    }

    func controlTextDidChange(_ obj: Notification) {
        mainStore.dispatch(
            UpdateNewTodo(text: (obj.object as! NSTextField).stringValue)
        )
    }
}

