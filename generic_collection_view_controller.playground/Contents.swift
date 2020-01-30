//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

//MARK: - Extensions

extension UIColor {
    class func randomColor() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    }
}

//MARK: - Structs

struct SourceAsset {
    var title: String
}

//MARK: - Classes

final class SourceAssetsViewController<Asset, Cell: UICollectionViewCell>: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var assets: [Asset] = []
    let reuseIdentifier = "Cell"
    let configure: (Cell, Asset) -> ()
    var didSelect: (Asset) -> () = { _ in }
    
    init(assets: [Asset], configure: (Cell, Asset) -> ()) {
        self.configure = configure
        self.assets = assets
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.registerClass(Cell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let asset = assets[indexPath.row]
        didSelect(asset)
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! Cell
        cell.layer.borderColor = UIColor.magentaColor().CGColor
        cell.layer.borderWidth = 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
        let asset = assets[indexPath.row]
        cell.layer.cornerRadius = 14
        cell.layer.masksToBounds = true
        configure(cell, asset)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
}

final class AssetCell: UICollectionViewCell {
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
}

//MARK: - Implementation

let sampleAssets = [
    SourceAsset(title: "First Episode"),
    SourceAsset(title: "Second Episode"),
    SourceAsset(title: "Third Episode")
]

let sourceVC = SourceAssetsViewController(assets: sampleAssets, configure: { (cell: AssetCell, asset) in
    cell.backgroundColor = UIColor.randomColor()
    cell.label.text = asset.title
    cell.label.textColor = .whiteColor()
    cell.label.frame = cell.bounds
    cell.addSubview(cell.label)
})

let nav = UINavigationController(rootViewController: sourceVC)
sourceVC.title = "Nav Bar"

sourceVC.didSelect = { asset in
    let pushSourceVC = SourceAssetsViewController(assets: sampleAssets, configure: { (cell: AssetCell, asset) in
        cell.backgroundColor = UIColor.randomColor()
        cell.label.text = asset.title
        cell.label.textColor = .whiteColor()
        cell.label.frame = cell.bounds
        cell.addSubview(cell.label)
    })
    nav.pushViewController(pushSourceVC, animated: true)
    
    pushSourceVC.title = asset.title
    pushSourceVC.didSelect = sourceVC.didSelect
}

nav.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
XCPlaygroundPage.currentPage.liveView = nav.view
 
