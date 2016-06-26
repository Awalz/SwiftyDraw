//
//  ViewController.swift
//  OpenSketch
//
//  Created by Andrew on 2016-01-06.
//

import UIKit


class ViewController: UIViewController {
    
    var smoothLineView : SwiftyLine = SwiftyLine()

    
    @IBOutlet weak var mainDrawingCanvas: UIImageView!
    @IBOutlet weak var deleteCurrentCanvasButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var blueColorButton: BlueButton!
    @IBOutlet weak var redColorButton: RedButton!
    @IBOutlet weak var greenColorButton: GreenButton!
    @IBOutlet weak var yellowColorButton: YellowButton!
    @IBOutlet weak var orangeColorButton: OrangeButton!
    @IBOutlet weak var purpleColorButton: PurpleButton!
    @IBOutlet weak var lineWidthSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smoothLineView = SwiftyLine(frame: mainDrawingCanvas.bounds)
        self.view.addSubview(smoothLineView)
        self.view.bringSubview(toFront: deleteCurrentCanvasButton)
        self.view.bringSubview(toFront: backButton)
        self.view.bringSubview(toFront: blueColorButton)
        self.view.bringSubview(toFront: redColorButton)
        self.view.bringSubview(toFront: greenColorButton)
        self.view.bringSubview(toFront: yellowColorButton)
        self.view.bringSubview(toFront: orangeColorButton)
        self.view.bringSubview(toFront: purpleColorButton)
        self.view.bringSubview(toFront: lineWidthSlider)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func deleteCurrentCanvas(_ sender: AnyObject) {
        smoothLineView.removeAllPaths()
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        smoothLineView.removeLastPath()
    }
   
    @IBAction func blueColorStroke(_ sender: AnyObject) {
        smoothLineView.lineColor = UIColor.blue()
    }
    
    @IBAction func redColorStroke(_ sender: AnyObject) {
        smoothLineView.lineColor = UIColor.red()
    }
    
    @IBAction func greenColorStroke(_ sender: AnyObject) {
        smoothLineView.lineColor = UIColor.green()
    }
    
    @IBAction func yellowColorStroke(_ sender: AnyObject) {
        smoothLineView.lineColor = UIColor.yellow()
    }
    
    @IBAction func orangeColorStroke(_ sender: AnyObject) {
        smoothLineView.lineColor = UIColor.orange()
    }
    
    @IBAction func purpleColorButton(_ sender: AnyObject) {
        smoothLineView.lineColor = UIColor.purple()
    }
    
    @IBAction func valueDidChange(_ sender: AnyObject) {
        let newWidth : Float = sender.value
        smoothLineView.lineWidth = CGFloat(newWidth)
    }
  
    func changeStrokeWidth(_ width: CGFloat) {
        smoothLineView.lineWidth = width
    }
}
