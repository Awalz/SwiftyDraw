import UIKit

extension ViewController: SwiftyDrawViewDelegate {
    
    func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool { return true }
    func swiftyDraw(didBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(isDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didFinishDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didCancelDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) {  }
}

class ViewController: UIViewController {
    
    @IBOutlet var drawView: SwiftyDrawView!
    @IBOutlet var eraserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawView.brush.width = 7
        
        if #available(iOS 9.1, *) {
            drawView.allowedTouchTypes = [.finger, .pencil]
        }
    }
    
    @IBAction func selectedColor(_ button: UIButton) {
        guard let color = button.backgroundColor else { return }
        drawView.brush.color = color
        drawView.brush.blendMode = .normal
    }
    
    @IBAction func undo() {
        drawView.undo()
    }
    
    @IBAction func redo() {
        drawView.redo()
    }
    
    @IBAction func activateEraser() {
        if drawView.brush.blendMode == .normal{
            //Switch to clear
            drawView.brush.blendMode = .clear
            eraserButton.tintColor = .red
            eraserButton.setTitle("deactivate eraser", for: .normal)
        } else {
            //Switch to normal
            drawView.brush.blendMode = .normal
            eraserButton.tintColor = self.view.tintColor
            eraserButton.setTitle("activate eraser", for: .normal)
        }
    }
    
    @IBAction func clearCanvas() {
        drawView.clear()
        drawView.brush.blendMode = .normal
    }
    
    @IBAction func changedWidth(_ slider: UISlider) {
        drawView.brush.width = CGFloat(slider.value)
    }
    
    @IBAction func changedOpacity(_ slider: UISlider) {
        drawView.brush.opacity = CGFloat(slider.value)
        drawView.brush.blendMode = .normal
    }
}

