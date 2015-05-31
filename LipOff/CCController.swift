import UIKit

class CCController : UIViewController {
    let lipOffRed = UIColor(red: 0.937, green: 0.333, blue: 0.31, alpha: 1)
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        createLogoBar()
        self.view.backgroundColor = lipOffRed
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
        
        var backButton = UIButton(frame: CGRect(x: 10, y: 8, width: 13, height: 22))
        backButton.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: Selector("goBack"), forControlEvents: UIControlEvents.TouchDown)
        logoTopBar.addSubview(backButton)
        
        self.view.addSubview(logoTopBar)
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
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
    
    @IBAction func linkKanye(sender: AnyObject) {
        if let url = NSURL(string: "http://de.wikipedia.org/wiki/Kanye_West#/media/File:Kanye_West_at_the_2009_Tribeca_Film_Festival.jpg") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func linkKim(sender: AnyObject) {
        if let url = NSURL(string: "https://www.flickr.com/photos/58820009@N05/15035346840/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func linkTaylor(sender: AnyObject) {
        if let url = NSURL(string: "http://de.wikipedia.org/wiki/Taylor_Swift#/media/File:TaylorSwiftApr09.jpg") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func linkRyan(sender: AnyObject) {
        if let url = NSURL(string: "https://www.flickr.com/photos/zaffi/13522475605/in/set-72157627446505460") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}