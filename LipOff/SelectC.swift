import UIKit


enum TILE_POSITION : Int {
    case TL = 0
    case TR = 1
    case BL = 2
    case BR = 3
    
    static func getLinkForPosition(position: TILE_POSITION) -> String {
        switch position {
        case .TL:
            return PREVIEW_LINKS.UPPER_LEFT.rawValue
        case .TR:
            return PREVIEW_LINKS.UPPER_RIGHT.rawValue
        case .BL:
            return PREVIEW_LINKS.LOWER_LEFT.rawValue
        case .BR:
            return PREVIEW_LINKS.UPPER_RIGHT.rawValue
        }
    }
}

class SelectC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var selectedTile : TILE_POSITION?
    var cells = [
        0 : CelelSelectCollectionViewCell(),
        1 : CelelSelectCollectionViewCell(),
        2 : CelelSelectCollectionViewCell(),
        3 : CelelSelectCollectionViewCell()
    ]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
            println("callback called")
            self.setPreviewImageForCell(cell, position: cellPosition)
            self.reloadImagesForPosition(cellPosition)
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
        getDataFromUrl(NSURL(string: TILE_POSITION.getLinkForPosition(position))!) { (data, error) -> Void in
            
            if let actualError = error {
                cell.setError()
                return
            }
            
            if let imageData = data {
                if let actualImage = UIImage(data: imageData) {
                    cell.setNewImage(actualImage)
                    cell.clickable = true
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)) {
            ImageRepository.sharedRepo.loadImagesFor(position)
        }
    }
    
    private func reloadImagesForPosition(position: TILE_POSITION) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)) {
            ImageRepository.sharedRepo.reloadImagesFor(position)
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