//
//  TodoTableView.swift
//  TodoList
//
//  Created by David Albert on 12/24/18.
//  Copyright © 2018 David Albert. All rights reserved.
//

import Cocoa

class TodoTableView: NSTableView {
    override func keyDown(with event: NSEvent) {
        if event.charactersIgnoringModifiers?.first == Character(UnicodeScalar(NSDeleteCharacter)!) {
            todoDelegate?.deleteKeyPressed(self, forRow: selectedRow)
        } else {
            super.keyDown(with: event)
        }
    }

    var todoDelegate: TodoTableViewDelegate? {
        return delegate as? TodoTableViewDelegate
    }
}

protocol TodoTableViewDelegate {
    func deleteKeyPressed(_ tableView: TodoTableView, forRow row: Int)
}
