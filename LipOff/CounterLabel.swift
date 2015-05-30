import UIKit

class CounterLabel : UILabel {
    var count = 0
    var counting = false
    var timer : NSTimer?
    var onFinished : (() -> Void)?
    var alsoUpdate : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func withCount(count: Int) -> CounterLabel {
        self.count = count
        self.counting = false
        return self
    }
    
    func startCounter(onFinished : (() -> Void)) {
        hidden = false
        self.counting = true
        setNewText("\(count)")
        self.onFinished = onFinished
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    func setNewText(newText : String) {
        self.text = newText
        alsoUpdate?.text = newText
    }
    
    func updateTimer() {
        self.count -= 1
        setNewText("\(count)")
        
        if self.count == 0 {
            self.timer?.invalidate()
            self.hidden = true
            self.onFinished?()
        }
    }
    
    private func setupUI() {
        hidden = true
        textAlignment = .Center
        font = UIFont(name: "SignPainter", size: 50)
        textColor = UIColor.whiteColor()
    }
}