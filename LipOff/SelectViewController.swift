import UIKit

class SelectViewController: UIViewController {
    let lipOffRed = UIColor(red: 0.937, green: 0.333, blue: 0.31, alpha: 1)
    var celebName = "Kanye"
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        createLogoBar()
        createCelebTyles()
        self.view.backgroundColor = UIColor.blueColor()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // LOGO TOP
    private func createLogoBar() {
        self.createLogoTopBar()
        self.addLipOffLogo()
    }
    
    private func createLogoTopBar() {
        var logoTopBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        logoTopBar.backgroundColor = lipOffRed
        self.view.addSubview(logoTopBar)
    }
    
    private func addLipOffLogo() {
        let widthOfTotal = 0.55
        let heightToWidth = 0.22
        
        var width = widthOfTotal * Double(self.view.frame.width)
        var height = width * heightToWidth
        var xValue = Double(self.view.frame.width / 2) - Double(width / 2)
        
        var lipOffLogo = UIImageView(frame: CGRect(x: Int(xValue), y: 8, width: Int(width), height: Int(height)))
        lipOffLogo.image = UIImage(named: "Logo")
        self.view.addSubview(lipOffLogo)
    }
    
    // CELEB TYLES
    private func createCelebTyles() {
        createUpperLeftTyle()
        createUpperRightTyle()
        createLowerLeftTyle()
        createLowerRightTyle()
    }
    
    func goToRecord() {
        self.performSegueWithIdentifier("goToRecord", sender: self)
    }
    
    func selectKanye() {
        celebName = "Kanye"
        goToRecord()
    }
    
    func selectKim() {
        celebName = "Kim"
        goToRecord()
    }
    
    func selectTaylor() {
        celebName = "Taylor"
        goToRecord()
    }
    
    func selectRyan() {
        celebName = "Ryan"
        goToRecord()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goToRecord") {
            
            var yourNextViewController = (segue.destinationViewController as! RecordViewController)
            yourNextViewController.celebName = self.celebName
        }
    }
    
    private func createUpperLeftTyle() {
        var height = (self.view.frame.height - 60) / 2
        var upperLeftTyle = UIImageView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width / 2, height: height))
        upperLeftTyle.image = UIImage(named: "Kanye")
        upperLeftTyle.layer.borderColor = UIColor.whiteColor().CGColor
        upperLeftTyle.layer.borderWidth = 3
        
        upperLeftTyle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("selectKanye")))
        upperLeftTyle.userInteractionEnabled = true
        
        self.view.addSubview(upperLeftTyle)
    }
    
    private func createUpperRightTyle() {
        var height = (self.view.frame.height - 60) / 2
        var upperRightTyle = UIImageView(frame: CGRect(x: self.view.frame.midX, y: 60, width: self.view.frame.width / 2, height: height))
        upperRightTyle.image = UIImage(named: "Kim")
        upperRightTyle.layer.borderColor = UIColor.whiteColor().CGColor
        upperRightTyle.layer.borderWidth = 3
        
        upperRightTyle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("selectKim")))
        upperRightTyle.userInteractionEnabled = true
        
        self.view.addSubview(upperRightTyle)
    }
    
    private func createLowerLeftTyle() {
        var height = (self.view.frame.height - 60) / 2
        var lowerLeftTyle = UIImageView(frame: CGRect(x: 0, y: 60 + height, width: self.view.frame.width / 2, height: height))
        lowerLeftTyle.image = UIImage(named: "Taylor")
        lowerLeftTyle.layer.borderColor = UIColor.whiteColor().CGColor
        lowerLeftTyle.layer.borderWidth = 3
        
        lowerLeftTyle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("selectTaylor")))
        lowerLeftTyle.userInteractionEnabled = true
        
        self.view.addSubview(lowerLeftTyle)
    }
    
    private func createLowerRightTyle() {
        var height = (self.view.frame.height - 60) / 2
        var lowerRightTyle = UIImageView(frame: CGRect(x: self.view.frame.midX, y: 60 + height, width: self.view.frame.width / 2, height: height))
        lowerRightTyle.image = UIImage(named: "RyanG")
        lowerRightTyle.layer.borderColor = UIColor.whiteColor().CGColor
        lowerRightTyle.layer.borderWidth = 3
        
        lowerRightTyle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectRyan"))
        lowerRightTyle.userInteractionEnabled = true
        
        self.view.addSubview(lowerRightTyle)
    }
}