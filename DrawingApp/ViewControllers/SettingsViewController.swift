//
//  SettingsController.swift
//  DrawingApp
//
//  Created by Gilles Vercammen on 1/2/18.
//  Copyright © 2018 Gilles Vercammen. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsFinalized(width: CGFloat, red: CGFloat, green: CGFloat, blue: CGFloat)
}

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var widthSlider: UISlider!
    
    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var greenSlider: UISlider!
    
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var widthLabel: UILabel!
    
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var greenLabel: UILabel!
    
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var exampleImageView: UIImageView!
    
    var width: CGFloat! {
        didSet {
            widthLabel?.text = NSString(format: "%.0f", (width?.native)!) as String
        }
    }
    
    var red: CGFloat! {
        didSet {
            redLabel?.text = NSString(format: "%.0f", (red?.native)! * 255) as String
        }
    }
    
    var green: CGFloat! {
        didSet {
            greenLabel?.text = NSString(format: "%.0f", (green?.native)! * 255) as String
        }
    }
    
    var blue: CGFloat! {
        didSet {
            blueLabel?.text = NSString(format: "%.0f", (blue?.native)! * 255) as String
        }
    }
    
    var initialWidth: CGFloat?
    
    var initialRed: CGFloat?
    
    var initialGreen: CGFloat?
    
    var initialBlue: CGFloat?
    
    weak var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset(self)
    }
    
    @IBAction
    func sliderChange(_ sender: UISlider!) {
        if sender == widthSlider {
            width = CGFloat(sender.value)
        } else if sender == redSlider {
            red = CGFloat(sender.value)
        } else if sender == greenSlider {
            green = CGFloat(sender.value)
        } else if sender == blueSlider {
            blue = CGFloat(sender.value)
        }
        drawExample()
    }
    
    func drawExample() {
        UIGraphicsBeginImageContext(exampleImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(width!)
        context?.setStrokeColor(red: red!, green: green!, blue: blue!, alpha: 1.0)
        
        let movePoint = CGPoint(x: exampleImageView.frame.size.width / 2, y: exampleImageView.frame.size.height / 2)
        context?.move(to: movePoint)
        context?.addLine(to: movePoint)
        context?.strokePath()
        exampleImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    @IBAction
    func save(_ sender: Any) {
        delegate?.settingsFinalized(width: width!, red: red!, green: green!, blue: blue!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction
    func reset(_ sender: Any) {
        width = initialWidth
        red = initialRed
        green = initialGreen
        blue = initialBlue
        widthSlider.setValue(Float((width?.native)!), animated: false)
        redSlider.setValue(Float((red?.native)!), animated: false)
        greenSlider.setValue(Float((green?.native)!), animated: false)
        blueSlider.setValue(Float((blue?.native)!), animated: false)
        drawExample()
    }
}

