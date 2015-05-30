import UIKit

class ShareDialog : UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        createWhatsappView()
        createMessageView()
    }
    
    private func createWhatsappView() {
        var whatsappButton = UIButton(frame: CGRectMake(15, 7, 42, 45))
        whatsappButton.setImage(UIImage(named: "whatsapp"), forState: UIControlState.Normal)
        whatsappButton.userInteractionEnabled = true
        
        self.addSubview(whatsappButton)
    }
    
    private func createMessageView() {
        var messageButton = UIButton(frame: CGRectMake(76, 7, 44, 44))
        messageButton.setImage(UIImage(named: "message"), forState: UIControlState.Normal)
        messageButton.userInteractionEnabled = true
        
        self.addSubview(messageButton)
    }
}
