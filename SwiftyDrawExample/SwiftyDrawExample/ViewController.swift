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
        drawView.brush.blendMode = .normal
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

