//
//  ContactViewCell.swift
//  Contacts
//
//  Created by 李文深 on 16/8/12.
//  Copyright © 2016年 30pay. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    func configCell(contact:Contact) {
        avatarImageView.image = contact.avatar
        nameLabel.text = contact.name
        phoneNumberLabel.text = contact.phoneNumber
    }

}
