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
    @IBOutlet var filterButtons: NSSegmentedControl!
    @IBOutlet var countLabel: NSTextField!
    @IBOutlet var clearButton: NSButton!

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

    func pluralize(_ count: Int, _ word: String) -> String {
        if count == 1 {
            return "\(count) \(word)"
        } else {
            return "\(count) \(word)s"
        }
    }

    func newState(state: State) {
        tableView.reloadData()
        addButton.isEnabled = !state.newTodo.isEmpty
        textField.stringValue = state.newTodo
        filterButtons.setSelected(true, forSegment: state.filter.rawValue)
        countLabel.stringValue = "\(pluralize(state.pendingTodos.count, "item")) left"
        clearButton.isEnabled = state.finishedTodos.count > 0

        if state.selectedRow >= 0 {
            tableView.selectRowIndexes([state.selectedRow], byExtendingSelection: false)
        } else {
            tableView.selectRowIndexes([], byExtendingSelection: false)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return mainStore.state.filteredTodos.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < mainStore.state.filteredTodos.count else {
            return nil
        }

        let todo = mainStore.state.filteredTodos[row]

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
        return mainStore.state.filteredTodos[row].id
    }

    func deleteKeyPressed(_ tableView: TodoTableView, forRow row: Int) {
        if row < 0 {
            return
        }

        mainStore.dispatch(
            RemoveTodo(id: id(forRow: row))
        )
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

    func controlTextDidChange(_ notification: Notification) {
        mainStore.dispatch(
            UpdateNewTodo(text: (notification.object as! NSTextField).stringValue)
        )
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow

        if row == mainStore.state.selectedRow {
            return
        }

        mainStore.dispatch(
            UpdateSelection(row: row)
        )
    }

    @IBAction func filterChanged(_ sender: NSSegmentedControl) {
        mainStore.dispatch(
            UpdateFilter(filter: Filter(rawValue: sender.selectedSegment)!)
        )
    }

    @IBAction func clearCompletedClicked(_ sender: NSButton) {
        mainStore.dispatch(
            ClearCompleted()
        )
    }
}

