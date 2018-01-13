//
//  FirstViewController.swift
//  DrawingApp
//
//  Created by Gilles Vercammen on 12/27/17.
//  Copyright © 2017 Gilles Vercammen. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {
    
    //The view that we draw on. We then later apply the drawing
    //to the main view.
    @IBOutlet
    weak var tempImageView: UIImageView!
    
    //The view that holds the drawing.
    @IBOutlet
    weak var mainImageView: UIImageView!
    
    //The description filled in by the user
    @IBOutlet weak var descriptionTextField: UITextField!
    
    //The last point we touched.
    var lastPoint = CGPoint.zero
    
    //The red value.
    var red: CGFloat = 0.0
    
    //The green value.
    var green: CGFloat = 0.0
    
    //The blue value.
    var blue: CGFloat = 0.0
    
    //The width of the brush.
    var brushWidth: CGFloat = 12.0
    
    //The opacity of the new drawing.
    var opacity: CGFloat = 1.0;
    
    //Whether or not we've moved yet.
    var swiped: Bool = false;
    
    //The drawing if we have one already
    var drawing: Drawing?
    
    //The drawing service to save to
    var drawingService: DrawingService?
    
    override func viewDidLoad() {
        mainImageView?.image = drawing?.image
        descriptionTextField?.text = drawing?.description
        tempImageView.layer.zPosition = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view);
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineWidth(brushWidth)
        context?.setLineCap(CGLineCap.round)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint;
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!swiped) {
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        swiped = false;
        
        UIGraphicsBeginImageContext(view.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y:0, width: view.frame.size.width, height: view.frame.size.height))
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        mainImageView.backgroundColor = UIColor(white: 1, alpha: 0)
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of: segue.destination) == SettingsViewController.self {
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.delegate = self
            settingsViewController.initialWidth = brushWidth
            settingsViewController.initialRed = red
            settingsViewController.initialBlue = blue
            settingsViewController.initialGreen = green
        }
    }
    
    @IBAction
    func save() {
        if (descriptionTextField.text?.isEmpty)! {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: descriptionTextField.center.x - 10, y: descriptionTextField.center.y ))
            animation.fromValue = NSValue(cgPoint: CGPoint(x: descriptionTextField.center.x + 10, y: descriptionTextField.center.y ))
            descriptionTextField.layer.add(animation, forKey: "position")
            return
        }
        var drawing: Drawing = Base64EncodedDrawing(author: UIDevice.current.name)
        drawing.image = mainImageView.image!
        drawing.description = descriptionTextField.text!
        drawingService?.save(drawing) {
            self.performSegue(withIdentifier: "unwindToMenu", sender: self)
        }
    }
}

extension DrawingViewController: SettingsViewControllerDelegate {
    func settingsFinalized(width: CGFloat, red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.brushWidth = width
        self.red = red
        self.green = green
        self.blue = blue
    }
}

