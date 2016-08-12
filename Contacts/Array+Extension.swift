//
//  Array+Extension.swift
//  Contacts
//
//  Created by 李文深 on 16/8/12.
//  Copyright © 2016年 30pay. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObjectAtIndexes(indexes: [Int]) {
        let indexSet = NSMutableIndexSet()
        
        for index in indexes {
            indexSet.addIndex(index)
        }
        
        indexSet.enumerateIndexesWithOptions(.Reverse) {
            self.removeAtIndex($0.0)
            return
        }
    }
    
    mutating func removeObjectAtIndexes(indexes: Int...) {
        removeObjectAtIndexes(indexes)
    }
}