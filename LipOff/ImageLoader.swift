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
//                    if let url = NSURL(string: "https://raw.githubusercontent.com/Ingelheim/LipOffAssets/master/LICENCES/CURRENT_LICENCES.png") {
}

class ImageRepository {
    // PREVIEW
    var upperLeftPreview : UIImage?
    var upperRightPreview : UIImage?
    var lowerLeftPreview : UIImage?
    var lowerRightPreview : UIImage?
    
    // ALPHA
    var upperLeftAlphaNormal : UIImage?
    var upperRightAlphaNormal : UIImage?
    var lowerLeftAlphaNormal : UIImage?
    var lowerRightAlphaNormal : UIImage?
    
    // FLIP
    var upperLeftAlphaFlip : UIImage?
    var upperRightAlphaFlip : UIImage?
    var lowerLeftAlphaFlip : UIImage?
    var lowerRightAlphaFlip : UIImage?
    
    // LICENCE
    var licences : UIImage?
    
    class var sharedRepo : ImageRepository {
        struct Static {
            static let instance : ImageRepository = ImageRepository()
        }
        return Static.instance
    }
    
    func setPreviewImageFor(image : UIImage, position: TILE_POSITION) {
        switch position {
        case .TL:
            upperLeftPreview = image
        case .TR:
            upperRightPreview = image
        case .BL:
            lowerLeftPreview = image
        case .BR:
            lowerRightPreview = image
        }
    }
    
    func getPreviewImageFor(position: TILE_POSITION) -> UIImage? {
        switch position {
        case .TL:
            return upperLeftPreview
        case .TR:
            return upperRightPreview
        case .BL:
            return lowerLeftPreview
        case .BR:
            return lowerRightPreview
        }
    }
    
    func setAlphaNormalImageFor(image : UIImage, position: TILE_POSITION) {
        switch position {
        case .TL:
            upperLeftAlphaNormal = image
        case .TR:
            upperRightAlphaNormal = image
        case .BL:
            lowerLeftAlphaNormal = image
        case .BR:
            lowerRightAlphaNormal = image
        }
    }
    
    func getAlphaNormalImageFor(position: TILE_POSITION) -> UIImage? {
        switch position {
        case .TL:
            return upperLeftAlphaNormal
        case .TR:
            return upperRightAlphaNormal
        case .BL:
            return lowerLeftAlphaNormal
        case .BR:
            return lowerRightAlphaNormal
        }
    }
    
    func setAlphaFlipImageFor(image : UIImage, position: TILE_POSITION) {
        switch position {
        case .TL:
            upperLeftAlphaFlip = image
        case .TR:
            upperRightAlphaFlip = image
        case .BL:
            lowerLeftAlphaFlip = image
        case .BR:
            lowerRightAlphaFlip = image
        }
    }
    
    func getAlphaFlipImageFor(position: TILE_POSITION) -> UIImage? {
        switch position {
        case .TL:
            return upperLeftAlphaFlip
        case .TR:
            return upperRightAlphaFlip
        case .BL:
            return lowerLeftAlphaFlip
        case .BR:
            return lowerRightAlphaFlip
        }
    }
}
