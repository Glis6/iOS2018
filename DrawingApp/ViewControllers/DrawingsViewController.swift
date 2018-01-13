//
//  DrawingCollectionViewController.swift
//  DrawingApp
//
//  Created by Gilles Vercammen on 1/3/18.
//  Copyright © 2018 Gilles Vercammen. All rights reserved.
//

import UIKit

class DrawingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let identifier = "drawingCell"
    
    let drawingService: DrawingService = KituraService.shared
    
    var drawings: [Drawing] = []
    
    var selectedDrawingIndex: IndexPath?
    
    @IBOutlet
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl?.addTarget(self, action: #selector(reload), for: UIControlEvents.valueChanged)
    }
    
    @objc func reload() {
        drawingService.getAll {
            if let drawings = $0 {
                self.drawings = drawings
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func clearSelection() {
        selectedDrawingIndex = nil
        self.performSegue(withIdentifier: "editDrawing", sender: self)
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of: segue.destination) == DrawingViewController.self {
            let drawingView: DrawingViewController = segue.destination as! DrawingViewController
            drawingView.drawingService = drawingService
            if selectedDrawingIndex != nil {
                drawingView.drawing = drawings[(selectedDrawingIndex?.row)!]
            }
        }
        if type(of: segue.destination) == CameraViewController.self {
            let cameraView: CameraViewController = segue.destination as! CameraViewController
            if selectedDrawingIndex != nil {
                cameraView.drawing = drawings[(selectedDrawingIndex?.row)!]
            }
        }
    }
}

extension DrawingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .normal, title: "Edit") {
                (action, view, completionHandler) in
                self.selectedDrawingIndex = indexPath
                self.performSegue(withIdentifier: "editDrawing", sender: self)
                completionHandler(true)
            }
            ])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedDrawingIndex = indexPath
        self.performSegue(withIdentifier: "openCamera", sender: self)
    }
}

extension DrawingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DrawingViewCell
        cell.drawing = drawings[indexPath.row]
        return cell
    }
}

