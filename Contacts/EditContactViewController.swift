//
//  EditContactViewController.swift
//  Contacts
//
//  Created by 李文深 on 16/8/12.
//  Copyright © 2016年 30pay. All rights reserved.
//

import UIKit

class EditContactViewController: UITableViewController {
    
    var contact: Contact!
    var editingIndexPath:NSIndexPath! //当前正在编辑上一个tableView的IndexPath
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑联系人"
        
        nameField.text = contact.name
        phoneNumberField.text = contact.phoneNumber
        avatarImageView.image = contact.avatar
        
        nameField.addTarget(self, action: #selector(EditContactViewController.updateSaveBarButtonState), forControlEvents: .EditingChanged)
        phoneNumberField.addTarget(self, action: #selector(EditContactViewController.updateSaveBarButtonState), forControlEvents: .EditingChanged)
    }
    
    @objc private func updateSaveBarButtonState() {
        
        print(#function)
        
        var enable = false
        
        if let _ = avatarImageView.image,
            let nameText = nameField.text where nameText.characters.count > 0,
            let phoneText = phoneNumberField.text where phoneText.characters.count > 0{
            enable = true
        }
        
        saveButton.enabled = enable
    }
    
    @IBAction func addAvatarAction() {
        
        let alertVC =  UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let choseLibraryAction = UIAlertAction(title: "相机", style: .Default, handler: { _ in
            
            guard UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) else {
                print("cannot open PhotoLibrary")
                return
            }
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        alertVC.addAction(choseLibraryAction)
        
        let choseTakePhotoAction = UIAlertAction(title: "拍照", style: .Default, handler: { _ in
            
            guard UIImagePickerController.isSourceTypeAvailable(.Camera) else {
                print("cannot open Camera")
                return
            }
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        alertVC.addAction(choseTakePhotoAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertVC.addAction(cancelAction)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }

}


//MARK: 头像处理
extension EditContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        defer {
            dismissViewControllerAnimated(true) {
//                self.updateSaveBarButtonState()
            }
        }
        
        avatarImageView.image = image
    }
}
