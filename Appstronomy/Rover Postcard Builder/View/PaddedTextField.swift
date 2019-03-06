//
//  PaddedTextField.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 06/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

@IBDesignable
class PaddedTextField: UITextField {

    let padding = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
