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
        self.view.bringSubviewToFront(deleteCurrentCanvasButton)
        self.view.bringSubviewToFront(backButton)
        self.view.bringSubviewToFront(blueColorButton)
        self.view.bringSubviewToFront(redColorButton)
        self.view.bringSubviewToFront(greenColorButton)
        self.view.bringSubviewToFront(yellowColorButton)
        self.view.bringSubviewToFront(orangeColorButton)
        self.view.bringSubviewToFront(purpleColorButton)
        self.view.bringSubviewToFront(lineWidthSlider)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func deleteCurrentCanvas(sender: AnyObject) {
        smoothLineView.removeAllPaths()
    }
    
    @IBAction func backButton(sender: AnyObject) {
        smoothLineView.removeLastPath()
    }
   
    @IBAction func blueColorStroke(sender: AnyObject) {
        smoothLineView.changeLineColor(UIColor.blueColor())
    }
    
    @IBAction func redColorStroke(sender: AnyObject) {
        smoothLineView.changeLineColor(UIColor.redColor())
    }
    
    @IBAction func greenColorStroke(sender: AnyObject) {
        smoothLineView.changeLineColor(UIColor.greenColor())
    }
    
    @IBAction func yellowColorStroke(sender: AnyObject) {
        smoothLineView.changeLineColor(UIColor.yellowColor())
    }
    
    @IBAction func orangeColorStroke(sender: AnyObject) {
        smoothLineView.changeLineColor(UIColor.orangeColor())
    }
    
    @IBAction func purpleColorButton(sender: AnyObject) {
        smoothLineView.changeLineColor(UIColor.purpleColor())
    }
    
    @IBAction func valueDidChange(sender: AnyObject) {
        let newValue : Float = sender.value
        smoothLineView.changeLineWidth(CGFloat(newValue))
    }
  
    func changeStrokeWidth(width: CGFloat) {
        lineWidth = width
    }
}
