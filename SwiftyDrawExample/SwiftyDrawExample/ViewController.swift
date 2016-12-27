/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit

class ViewController: UIViewController, SwiftyDrawViewDelegate {
    
    var drawView : SwiftyDrawView!
    var redButton : ColorButton!
    var greenButton : ColorButton!
    var blueButton : ColorButton!
    var orangeButton : ColorButton!
    var purpleButton : ColorButton!
    var yellowButton : ColorButton!
    var undoButton : UIButton!
    var deleteButton : UIButton!
    var lineWidthSlider : UISlider!
    var opacitySlider : UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        drawView = SwiftyDrawView(frame: self.view.frame)
        drawView.delegate = self
        self.view.addSubview(drawView)
        addButtons()
        addSliders()
    }
    
    func addButtons() {
        redButton = ColorButton(frame: CGRect(x: 10, y: self.view.frame.height - 50, width: 40, height: 40), color: UIColor.red)
        redButton.addTarget(self, action: #selector(colorButtonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(redButton)
        
        greenButton = ColorButton(frame: CGRect(x: 10, y: self.view.frame.height - 100, width: 40, height: 40), color: UIColor.green)
        greenButton.addTarget(self, action: #selector(colorButtonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(greenButton)
        
        blueButton = ColorButton(frame: CGRect(x: 10, y: self.view.frame.height - 150, width: 40, height: 40), color: UIColor.blue)
        blueButton.addTarget(self, action: #selector(colorButtonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(blueButton)
        
        orangeButton = ColorButton(frame: CGRect(x: 60, y: self.view.frame.height - 150, width: 40, height: 40), color: UIColor.orange)
        orangeButton.addTarget(self, action: #selector(colorButtonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(orangeButton)
        
        purpleButton = ColorButton(frame: CGRect(x: 60, y: self.view.frame.height - 100, width: 40, height: 40), color: UIColor.purple)
        purpleButton.addTarget(self, action: #selector(colorButtonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(purpleButton)
        
        yellowButton = ColorButton(frame: CGRect(x: 60, y: self.view.frame.height - 50, width: 40, height: 40), color: UIColor.yellow)
        yellowButton.addTarget(self, action: #selector(colorButtonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(yellowButton)
        
        undoButton = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 30, width: 60, height: 30))
        undoButton.setTitleColor(UIColor.black, for: UIControlState())
        undoButton.setTitle("undo", for: UIControlState())
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        self.view.addSubview(undoButton)
        
        deleteButton = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 60, width: 60, height: 30))
        deleteButton.setTitleColor(UIColor.black, for: UIControlState())
        deleteButton.setTitle("delete", for: UIControlState())
        deleteButton.addTarget(self, action: #selector(deleteDrawing), for: .touchUpInside)
        self.view.addSubview(deleteButton)
    }
    
    func addSliders() {
        lineWidthSlider = UISlider(frame: CGRect(x: 120, y: self.view.frame.height - 50, width: 100, height: 40))
        lineWidthSlider.minimumValue = 1.0
        lineWidthSlider.maximumValue = 30.0
        lineWidthSlider.setValue(10.0, animated: false)
        lineWidthSlider.isContinuous = true
        lineWidthSlider.addTarget(self, action: #selector(lineWidthSliderValueDidChange(sender:)), for: .valueChanged)
        self.view.addSubview(lineWidthSlider)
        
        opacitySlider = UISlider(frame: CGRect(x: 120, y: self.view.frame.height - 80, width: 100, height: 40))
        opacitySlider.minimumValue = 0.001
        opacitySlider.maximumValue = 1.0
        opacitySlider.setValue(1.0, animated: false)
        opacitySlider.isContinuous = true
        opacitySlider.addTarget(self, action: #selector(lineOpacitySliderValueDidChange(sender:)), for: .valueChanged)
        self.view.addSubview(opacitySlider)
    }
    
    func colorButtonPressed(button: ColorButton) {
        drawView.lineColor = button.color
    }
    
    func undo() {
        drawView.removeLastLine()
    }
    
    func deleteDrawing() {
        drawView.clearCanvas()
    }
    
    func lineWidthSliderValueDidChange(sender:UISlider!) {
        drawView.lineWidth = CGFloat(sender.value)
    }
    
    func lineOpacitySliderValueDidChange(sender:UISlider!) {
        drawView.lineOpacity = CGFloat(sender.value)
    }
    
    func SwiftyDrawDidBeginDrawing(view: SwiftyDrawView) {
        print("Did begin drawing")
        UIView.animate(withDuration: 0.5, animations: {
            self.redButton.alpha = 0.0
            self.blueButton.alpha = 0.0
            self.greenButton.alpha = 0.0
            self.orangeButton.alpha = 0.0
            self.purpleButton.alpha = 0.0
            self.yellowButton.alpha = 0.0
            self.undoButton.alpha = 0.0
            self.deleteButton.alpha = 0.0
            self.lineWidthSlider.alpha = 0.0
            self.opacitySlider.alpha = 0.0
        })
    }
    
    func SwiftyDrawIsDrawing(view: SwiftyDrawView) {
        print("Is Drawing")
    }
    
    func SwiftyDrawDidFinishDrawing(view: SwiftyDrawView) {
        print("Did finish drawing")
        UIView.animate(withDuration: 0.5, animations: {
            self.redButton.alpha = 1.0
            self.blueButton.alpha = 1.0
            self.greenButton.alpha = 1.0
            self.orangeButton.alpha = 1.0
            self.purpleButton.alpha = 1.0
            self.yellowButton.alpha = 1.0
            self.undoButton.alpha = 1.0
            self.deleteButton.alpha = 1.0
            self.lineWidthSlider.alpha = 1.0
            self.opacitySlider.alpha = 1.0
        })
    }
    
    func SwiftyDrawDidCancelDrawing(view: SwiftyDrawView) {
        print("Did cancel")
    }
}

