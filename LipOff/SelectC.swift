import UIKit


enum TILE_POSITION : Int {
    case TL = 0
    case TR = 1
    case BL = 2
    case BR = 3
    
    static func getPreviewLinkForPosition(position: TILE_POSITION) -> String {
        switch position {
        case .TL:
            return PREVIEW_LINKS.UPPER_LEFT.rawValue
        case .TR:
            return PREVIEW_LINKS.UPPER_RIGHT.rawValue
        case .BL:
            return PREVIEW_LINKS.LOWER_LEFT.rawValue
        case .BR:
            return PREVIEW_LINKS.LOWER_RIGHT.rawValue
        }
    }
    
    static func getAlphaNormalLinkForPosition(position: TILE_POSITION) -> String {
        switch position {
        case .TL:
            return CELEBRITY_IMAGE_NORMAL.UPPER_LEFT.rawValue
        case .TR:
            return CELEBRITY_IMAGE_NORMAL.UPPER_RIGHT.rawValue
        case .BL:
            return CELEBRITY_IMAGE_NORMAL.LOWER_LEFT.rawValue
        case .BR:
            return CELEBRITY_IMAGE_NORMAL.LOWER_RIGHT.rawValue
        }
    }
    
    static func getAlphaFlipLinkForPosition(position: TILE_POSITION) -> String {
        switch position {
        case .TL:
            return CELEBRITY_IMAGE_MIRRORED.UPPER_LEFT.rawValue
        case .TR:
            return CELEBRITY_IMAGE_MIRRORED.UPPER_RIGHT.rawValue
        case .BL:
            return CELEBRITY_IMAGE_MIRRORED.LOWER_LEFT.rawValue
        case .BR:
            return CELEBRITY_IMAGE_MIRRORED.LOWER_RIGHT.rawValue
        }
    }
}

class SelectC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var imageRepo = ImageRepository.sharedRepo
    var selectedTile : TILE_POSITION?
    
    var cells = [
        0 : CelelSelectCollectionViewCell(),
        1 : CelelSelectCollectionViewCell(),
        2 : CelelSelectCollectionViewCell(),
        3 : CelelSelectCollectionViewCell()
    ]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var reloadAll: UIImageView!
    @IBAction func reloadTiles(sender: AnyObject) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Reload Images", message: "Do you really want to reaload the images?", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        
        let reloadAction: UIAlertAction = UIAlertAction(title: "Reload Images", style: .Default) { action -> Void in
            self.collectionView.reloadData()
        }
        actionSheetController.addAction(reloadAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "CelelSelectCollectionViewCell", bundle: NSBundle(forClass: self.dynamicType)), forCellWithReuseIdentifier: "selectCeleb")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("selectCeleb", forIndexPath: indexPath) as! CelelSelectCollectionViewCell
        var cellPosition = TILE_POSITION(rawValue: indexPath.item)!
        
        cell.reloadCallback = {
            self.setPreviewImageForCell(cell, position: cellPosition)
            self.reloadImagesForPosition(cellPosition, cell: cell)
        }
        
        cells[indexPath.item] = cell
        setPreviewImageForCell(cell, position: cellPosition)
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
  
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width = collectionView.bounds.size.width / 2
        var height = collectionView.bounds.size.height / 2

        return CGSizeMake(width, height)
    }
    
    func setPreviewImageForCell(cell : CelelSelectCollectionViewCell, position: TILE_POSITION) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            self.loadImagesForPosition(position, cell: cell)
        }
    }
    
    func loadImagesForPosition(position: TILE_POSITION, cell: CelelSelectCollectionViewCell) {        
        self.loadImageForURL(NSURL(string: TILE_POSITION.getPreviewLinkForPosition(position))!, callback: { (data, error) -> Void in
            if(error) {
                cell.setError()
                return
            } else {
                self.imageRepo.setPreviewImageFor(UIImage(data: data)!, position: position)
            }
            self.loadImageForURL(NSURL(string: TILE_POSITION.getAlphaNormalLinkForPosition(position))!, callback: { (data, error) -> Void in
                if(error) {
                    cell.setError()
                    return
                } else {
                    self.imageRepo.setAlphaNormalImageFor(UIImage(data: data)!, position: position)
                }
                
                self.loadImageForURL(NSURL(string: TILE_POSITION.getAlphaFlipLinkForPosition(position))!, callback: { (data, error) -> Void in
                    if(error) {
                        cell.setError()
                        return
                    } else {
                        self.imageRepo.setAlphaFlipImageFor(UIImage(data: data)!, position: position)
                        cell.setNewImage(self.imageRepo.getPreviewImageFor(position)!)
                        cell.clickable = true
                    }
                })
            })
        })
    }
    
    func loadImageForURL(url: NSURL, callback: (data : NSData, error : Bool) -> Void) {
        getDataFromUrl(url, completion: { (data, error) -> Void in
            callback(data: data!, error: error != nil)
        })
    }
    
    private func reloadImagesForPosition(position: TILE_POSITION, cell: CelelSelectCollectionViewCell) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            self.loadImagesForPosition(position, cell: cell)
        }
    }
    
    private func getDataFromUrl(urL:NSURL, completion: ((data: NSData?, error: NSError?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data, error: error)
        }.resume()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if cells[indexPath.item]!.clickable {
            selectedTile = TILE_POSITION(rawValue: indexPath.item)
            self.performSegueWithIdentifier("goToRecord", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToRecord") {
            
            var yourNextViewController = (segue.destinationViewController as! RecordViewController)
            yourNextViewController.selectedTile = self.selectedTile!
        }
    }
    
}