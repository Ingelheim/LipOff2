import UIKit

enum PREVIEW_LINKS : String {
    case UPPER_LEFT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/UPPER_LEFT/PREVIEW.png"
    case UPPER_RIGHT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/UPPER_RIGHT/PREVIEW.png"
    case LOWER_LEFT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/LOWER_LEFT/PREVIEW.png"
    case LOWER_RIGHT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/LOWER_RIGHT/PREVIEW.png"
}

enum CELEBRITY_IMAGE_NORMAL : String {
    case UPPER_LEFT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/UPPER_LEFT/ALPHA.png"
    case UPPER_RIGHT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/UPPER_RIGHT/ALPHA.png"
    case LOWER_LEFT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/LOWER_LEFT/ALPHA.png"
    case LOWER_RIGHT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/LOWER_RIGHT/ALPHA.png"
}

enum CELEBRITY_IMAGE_MIRRORED : String {
    case UPPER_LEFT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/UPPER_LEFT/FLIP.png"
    case UPPER_RIGHT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/UPPER_RIGHT/FLIP.png"
    case LOWER_LEFT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/LOWER_LEFT/FLIP.png"
    case LOWER_RIGHT = "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/LOWER_RIGHT/FLIP.png"
}

class ImageRepository {
    var upperLeftNormal : UIImage {
        get {
            if(_upperLeftNormal == nil) {
                _upperLeftNormal = UIImage()
                if let url = NSURL(string: CELEBRITY_IMAGE_NORMAL.UPPER_LEFT.rawValue) {
                    if let data = NSData(contentsOfURL: url) {
                        _upperLeftNormal = UIImage(data: data)!
                    }
                }
            }
            return _upperLeftNormal!
        }
    }
    var _upperLeftNormal : UIImage?
    
    var upperRightNormal : UIImage {
        get {
            if(_upperRightNormal == nil) {
                _upperRightNormal = UIImage()
                if let url = NSURL(string: CELEBRITY_IMAGE_NORMAL.UPPER_RIGHT.rawValue) {
                    if let data = NSData(contentsOfURL: url) {
                        _upperRightNormal = UIImage(data: data)!
                    }
                }
            }
            return _upperRightNormal!
        }
    }
    var _upperRightNormal : UIImage?
    
    var lowerLeftNormal : UIImage {
        get {
            if(_lowerLeftNormal == nil) {
                _lowerLeftNormal = UIImage()
                if let url = NSURL(string: CELEBRITY_IMAGE_NORMAL.LOWER_LEFT.rawValue) {
                    if let data = NSData(contentsOfURL: url) {
                        _lowerLeftNormal = UIImage(data: data)!
                    }
                }
            }
            return _lowerLeftNormal!
        }
    }
    var _lowerLeftNormal : UIImage?
    
    var lowerRightNormal : UIImage {
        get {
            if(_lowerRightNormal == nil) {
                _lowerRightNormal = UIImage()
                if let url = NSURL(string: CELEBRITY_IMAGE_NORMAL.LOWER_RIGHT.rawValue) {
                    if let data = NSData(contentsOfURL: url) {
                        _lowerRightNormal = UIImage(data: data)!
                    }
                }
            }
            return _lowerRightNormal!
        }
    }
    var _lowerRightNormal : UIImage?
    
    var upperLeftAlpha : UIImage {
        get {
            if(_upperLeftAlpha == nil) {
                _upperLeftAlpha = UIImage()
                if let url = NSURL(string: CELEBRITY_IMAGE_MIRRORED.UPPER_LEFT.rawValue) {
                    if let data = NSData(contentsOfURL: url) {
                        _upperLeftAlpha = UIImage(data: data)!
                    }
                }
            }
            return _upperLeftAlpha!
        }
    }
    var _upperLeftAlpha : UIImage?
    
    var upperRightAlpha : UIImage {
        get {
            if(_upperRightAlpha == nil) {
                _upperRightAlpha = UIImage()
                if let url = NSURL(string: CELEBRITY_IMAGE_MIRRORED.UPPER_RIGHT.rawValue) {
                    if let data = NSData(contentsOfURL: url) {
                        _upperRightAlpha = UIImage(data: data)!
                    }
                }
            }
            return _upperRightAlpha!
        }
    }
    var _upperRightAlpha : UIImage?
    
    var lowerLeftAlpha : UIImage {
        get {
            if(_lowerLeftAlpha == nil) {
                _lowerLeftAlpha = UIImage()
                if let url = NSURL(string: CELEBRITY_IMAGE_MIRRORED.LOWER_LEFT.rawValue) {
                    if let data = NSData(contentsOfURL: url) {
                        _lowerLeftAlpha = UIImage(data: data)!
                    }
                }
            }
            return _lowerLeftAlpha!
        }
    }
    var _lowerLeftAlpha : UIImage?
    
    var lowerRightAlpha : UIImage {
        get {
            if(_lowerRightAlpha == nil) {
                _lowerRightAlpha = UIImage()
                if let url = NSURL(string: CELEBRITY_IMAGE_MIRRORED.LOWER_RIGHT.rawValue) {
                    if let data = NSData(contentsOfURL: url) {
                        _lowerRightAlpha = UIImage(data: data)!
                    }
                }
            }
            return _lowerRightAlpha!
        }
    }
    var _lowerRightAlpha : UIImage?
    
    var licences : UIImage {
        get {
            if(_licences == nil) {
                _licences = UIImage()
                if let url = NSURL(string: "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/LICENCES/CURRENT_LICENCES.png") {
                    if let data = NSData(contentsOfURL: url) {
                        _licences = UIImage(data: data)!
                    }
                }
            }
            return _licences!
        }
    }
    var _licences : UIImage?
    
    class var sharedRepo : ImageRepository {
        struct Static {
            static let instance : ImageRepository = ImageRepository()
        }
        return Static.instance
    }
    
    func loadImagesFor(position : TILE_POSITION) {
        switch position {
        case .TL:
            var temp1 = self.upperLeftNormal
            var temp2 = self.upperLeftAlpha
        case .TR:
            var temp1 = self.upperRightNormal
            var temp2 = self.upperRightAlpha
        case .BL:
            var temp1 = self.lowerLeftNormal
            var temp2 = self.lowerLeftAlpha
        case .BR:
            var temp1 = self.lowerRightNormal
            var temp2 = self.lowerRightAlpha
        }
        
        var temp3 = self.licences
    }
    
    func reloadImagesFor(position : TILE_POSITION) {
        switch position {
        case .TL:
            self._upperLeftNormal = nil
            self._upperLeftAlpha = nil
        case .TR:
            self._upperRightNormal = nil
            self._upperRightAlpha = nil
        case .BL:
            self._lowerLeftNormal = nil
            self._lowerLeftAlpha = nil
        case .BR:
            self._lowerRightNormal = nil
            self._lowerRightAlpha = nil
        }
        
        self._licences = nil
        
        loadImagesFor(position)
    }
    
    func setAlphaImageFor(#position: TILE_POSITION, callback: (image: UIImage) -> Void) {
        switch position {
        case .TL:
            callback(image: self.upperLeftNormal)
        case .TR:
            callback(image: self.upperRightNormal)
        case .BL:
            callback(image: self.lowerLeftNormal)
        case .BR:
            callback(image: self.lowerRightNormal)
        }
    }
    
    func getImageFor(#position: TILE_POSITION) -> UIImage {
        switch position {
        case .TL:
            return self.upperLeftAlpha
        case .TR:
            return self.upperRightAlpha
        case .BL:
            return self.lowerLeftAlpha
        case .BR:
            return self.lowerRightAlpha
        }
    }
}
