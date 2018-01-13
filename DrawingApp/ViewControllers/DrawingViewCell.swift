//
//  DrawingViewCell.swift
//  DrawingApp
//
//  Created by Gilles Vercammen on 1/3/18.
//  Copyright © 2018 Gilles Vercammen. All rights reserved.
//

import UIKit

class DrawingViewCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    var drawing: Drawing! {
        didSet {
            authorLabel?.text = drawing.author
            descriptionLabel?.text = drawing.description
            imagePreview?.image = drawing.image.changeWhiteColorTransparent()
        }
    }
}
