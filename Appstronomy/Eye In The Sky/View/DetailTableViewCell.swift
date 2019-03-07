//
//  DetailTableViewCell.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 07/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DetailCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: DetailTableViewCell.reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
