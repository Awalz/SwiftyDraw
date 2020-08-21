import UIKit

extension ViewController: SwiftyDrawViewDelegate {
    func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool { return true }
    func swiftyDraw(didBeginDrawingIn    drawingView: SwiftyDrawView, using touch: UITouch) { updateHistoryButtons() }
    func swiftyDraw(isDrawingIn          drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didFinishDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didCancelDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var drawView: SwiftyDrawView!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var fillModeButton: UIButton!
    @IBOutlet weak var drawModeSelector: UISegmentedControl!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHistoryButtons()
        
        drawView.delegate = self
        drawView.brush.width = 7
        
        if #available(iOS 9.1, *) {
            drawView.allowedTouchTypes = [.finger, .pencil]
        }
    }
    
    @IBAction func selectedColor(_ button: UIButton) {
        guard let color = button.backgroundColor else { return }
        drawView.brush.color = Color(color)
        deactivateEraser()
    }
    
    @IBAction func undo() {
        drawView.undo()
        updateHistoryButtons()
    }
    
    @IBAction func redo() {
        drawView.redo()
        updateHistoryButtons()
    }
    
    func updateHistoryButtons() {
        undoButton.isEnabled = drawView.canUndo
        redoButton.isEnabled = drawView.canRedo
    }
    
    @IBAction func toggleEraser() {
        if drawView.brush.blendMode == .normal {
            //Switch to clear
            activateEraser()
        } else {
            //Switch to normal
            deactivateEraser()
        }
    }
    
    @IBAction func clearCanvas() {
        drawView.clear()
        deactivateEraser()
    }
    
    @IBAction func setDrawMode() {
        switch (drawModeSelector.selectedSegmentIndex) {
        case 1:
            drawView.drawMode = .line
            fillModeButton.isHidden = true
            break
        case 2:
            drawView.drawMode = .ellipse
            fillModeButton.isHidden = false
            break
        case 3:
            drawView.drawMode = .rect
            fillModeButton.isHidden = false
            break
        default:
            drawView.drawMode = .draw
            fillModeButton.isHidden = true
            break
        }
    }
    
    @IBAction func toggleStraightLine() {
        drawView.shouldFillPath = !drawView.shouldFillPath
        if (drawView.shouldFillPath) {
            fillModeButton.tintColor = .red
            fillModeButton.setTitle("activate stroke mode", for: .normal)
        } else {
            fillModeButton.tintColor = self.view.tintColor
            fillModeButton.setTitle("activate fill mode", for: .normal)
        }
    }
        
    @IBAction func changedWidth(_ slider: UISlider) {
        drawView.brush.width = CGFloat(slider.value)
    }
    
    @IBAction func changedOpacity(_ slider: UISlider) {
        drawView.brush.opacity = CGFloat(slider.value)
        deactivateEraser()
    }
    
    func activateEraser() {
        drawView.brush.blendMode = .clear
        eraserButton.tintColor = .red
        eraserButton.setTitle("deactivate eraser", for: .normal)
    }
    
    func deactivateEraser() {
        drawView.brush.blendMode = .normal
        eraserButton.tintColor = self.view.tintColor
        eraserButton.setTitle("activate eraser", for: .normal)
    }
}

