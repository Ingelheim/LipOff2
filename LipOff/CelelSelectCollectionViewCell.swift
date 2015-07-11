import UIKit

class CelelSelectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    var clickable = false
    @IBOutlet weak var errorLabel: UIImageView!
    @IBOutlet weak var reloadButton: UIImageView!
    var reloadCallback : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.reloadButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("reloadImage")))
    }
    
    internal func setNewImage(image: UIImage) {
        dispatch_async(dispatch_get_main_queue(), {
            self.activity.stopAnimating()
            self.imageView.image = image
            self.errorLabel.hidden = true
            self.reloadButton.hidden = true
        })
    }
    
    func setError() {
        dispatch_async(dispatch_get_main_queue(), {
            self.reloadButton.userInteractionEnabled = true
            self.activity.stopAnimating()
            self.errorLabel.hidden = false
            self.reloadButton.hidden = false
        })
    }
    
    func reloadImage() {
        self.reloadButton.userInteractionEnabled = false
        reloadCallback?()
    }
}
