//
//  ContactListViewController.swift
//  Contacts
//
//  Created by 李文深 on 16/8/11.
//  Copyright © 2016年 30pay. All rights reserved.
//  https://developer.apple.com/library/ios/samplecode/TableMultiSelect/Introduction/Intro.html

import UIKit

class ContactListViewController: UITableViewController {
    
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
//    var dataArray = [["avatar":"1.jpeg","name":"Kobe","phone":"18823416735"],
//                      ["avatar":"2.jpeg","name":"Durant","phone":"123234598672"],
//                      ["avatar":"3.jpeg","name":"Wade","phone":"17723654343"],
//                      ["avatar":"4.jpeg","name":"Curry","phone":"1382343435"]
//                      ]
    
    private lazy var dataArray:[Contact] = {
        
        var c1 = Contact()
        c1.avatar = UIImage(named: "1.jpeg")
        c1.name = "Kobe"
        c1.phoneNumber = "18823416735"
        
        var c2 = Contact()
        c2.avatar = UIImage(named: "2.jpeg")
        c2.name = "Durant"
        c2.phoneNumber = "123234598672"
        
        var c3 = Contact()
        c3.avatar = UIImage(named: "3.jpeg")
        c3.name = "Wade"
        c3.phoneNumber = "17723654343"
        
        var c4 = Contact()
        c4.avatar = UIImage(named: "4.jpeg")
        c4.name = "Curry"
        c4.phoneNumber = "1382343435"
        
        return [c1,c2,c3,c4]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "联系人"
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        updateButtonsToMatchTableState()
    }
    
    private func updateButtonsToMatchTableState() {
        if tableView.editing {
            
            // Show the option to cancel the edit.
            navigationItem.rightBarButtonItem = cancelButton
            
            updateDeleteButtonTitle()
            
            // Show the delete button.
            navigationItem.leftBarButtonItem = deleteButton
        } else {
            // Not in editing mode.
            navigationItem.leftBarButtonItem = addButton
            
            // Show the edit button, but disable the edit button if there's nothing to edit.
            if (dataArray.count > 0) {
                editButton.enabled = true
            }else{
                editButton.enabled = false
            }
            navigationItem.rightBarButtonItem = editButton

        }
    }
    
    private func updateDeleteButtonTitle() {
        
        deleteButton.title = "Delete All"
        if let selectedRows = tableView.indexPathsForSelectedRows where selectedRows.count != dataArray.count { //有选中的行并且没有全选
            deleteButton.title = "Delete (\(selectedRows.count))"
        }
        
    }
    
    //MARK: - Unwind Segue Methods
    @IBAction func addContact(segue: UIStoryboardSegue) {
        
        let sourceVC = segue.sourceViewController as! AddContactViewController
        
        let avatarImage = sourceVC.avatarImageView.image
        let name        = sourceVC.nameField.text
        let phoneNumber = sourceVC.phoneNumberField.text
        let contact     = Contact()
        contact.avatar = avatarImage
        contact.name = name!
        contact.phoneNumber = phoneNumber!
        
        dataArray.append(contact)
        tableView.reloadData()
    }
    
    
    @IBAction func saveContact(segue: UIStoryboardSegue) {
        
        let sourceVC = segue.sourceViewController as! EditContactViewController
        
        let avatarImage = sourceVC.avatarImageView.image
        let name        = sourceVC.nameField.text
        let phoneNumber = sourceVC.phoneNumberField.text
        
        let contact     = Contact()
        contact.avatar = avatarImage
        contact.name = name!
        contact.phoneNumber = phoneNumber!
        
        let indexPath = sourceVC.editingIndexPath
        dataArray[indexPath.row] = contact  //替换原来的数据
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EditContactViewController" {
            let cell = sender as! ContactViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let vc = segue.destinationViewController as! EditContactViewController
            vc.contact = dataArray[indexPath!.row]
            vc.editingIndexPath = indexPath
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !tableView.editing
    }
    
}

// MARK: - Table view data source
extension ContactListViewController {
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as! ContactViewCell
        
        let contact = dataArray[indexPath.row]
        
        cell.configCell(contact)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if !tableView.editing {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        updateButtonsToMatchTableState()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        updateDeleteButtonTitle()
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            dataArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        case .Insert,.None:
            break
        }
    }
}

//MARK:actions
extension ContactListViewController {
    
    @IBAction func editAction(sender: UIBarButtonItem) {
        
        tableView.setEditing(false, animated: true) //适配在删除编辑状态下出现的UI的bug
        tableView.setEditing(true, animated: true)
        updateButtonsToMatchTableState()
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        tableView.setEditing(false, animated: true)
        updateButtonsToMatchTableState()
    }
    
    @IBAction func deleteAction(sender: UIBarButtonItem) {
        
        let alertVC =  UIAlertController(title: "tip", message: "Are you sure to delete", preferredStyle: .ActionSheet)
        let confirmAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { _ in
            
           if let selectedRows = self.tableView.indexPathsForSelectedRows {
            
                var indicesOfItemsToDelete = [Int]()
                for selectionIndex in selectedRows {
                    indicesOfItemsToDelete.append(selectionIndex.row)
                }
                self.dataArray.removeObjectAtIndexes(indicesOfItemsToDelete)
                self.tableView.deleteRowsAtIndexPaths(selectedRows, withRowAnimation: .Automatic)
            
           } else {
               self.dataArray.removeAll()
               self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            }
            
            
            // Exit editing mode after the deletion.
            self.tableView.setEditing(false, animated: true)
            self.updateButtonsToMatchTableState()
            
        })
        alertVC.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Calcel", style: .Cancel, handler: nil)
        alertVC.addAction(cancelAction)
        self.presentViewController(alertVC, animated: true, completion: nil)
        
    }
}
