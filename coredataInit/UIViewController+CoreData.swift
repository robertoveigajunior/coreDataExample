//
//  UIViewController+CoreData.swift
//  coredataInit
//
//  Created by Usuário Convidado on 03/04/17.
//  Copyright © 2017 roberto. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}

