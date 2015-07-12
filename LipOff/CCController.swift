import UIKit

class CCController : UIViewController {
    let lipOffRed = UIColor(red: 0.937, green: 0.333, blue: 0.31, alpha: 1)
    
    @IBOutlet weak var licencesView: UIImageView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        getDataFromUrl(NSURL(string: "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/LICENCES/CURRENT_LICENCES.png")!, completion: { (data, error) -> Void in
            if (error ==  nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.licencesView.image = UIImage(data: data!)
                })
            }
        })
    }
    
    private func getDataFromUrl(urL:NSURL, completion: ((data: NSData?, error: NSError?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data, error: error)
            }.resume()
    }
    
    override func viewDidLoad() {
        createLogoBar()
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
}