//
//  BarcodeCaroselViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/17.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeCarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barcodeCarousel: iCarousel!
    var dataSource: [BarcodeEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = fetchAllBarcodes()
        
        barcodeCarousel.type = iCarouselType.InvertedCylinder
        barcodeCarousel.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Carousel
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return dataSource.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var itemView: UIImageView
        if (view == nil)
        {
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:200, height:200))
            itemView.contentMode = .ScaleAspectFit
        }
        else
        {
            itemView = view as! UIImageView;
        }
        itemView.image = generateCode(dataSource[index])
        return itemView
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        if barcodeCarousel.currentItemIndex < 0 || barcodeCarousel.currentItemIndex >= dataSource.count {
            return
        }
        titleLabel.text = dataSource[barcodeCarousel.currentItemIndex].code
        print("We are at \(barcodeCarousel.currentItemIndex): [\(dataSource[barcodeCarousel.currentItemIndex].code)]")
    }
    
    // MARK: - Render codes
    
    func generateCode(barcode: BarcodeEntity) -> UIImage? {
        var encoding  = "CIQRCodeGenerator"
        switch barcode.type {
        case AVMetadataObjectTypeCode128Code:
            encoding = "CICode128BarcodeGenerator"
        case AVMetadataObjectTypePDF417Code:
            encoding = "CIPDF417BarcodeGenerator"
        case AVMetadataObjectTypeAztecCode:
            encoding = "CIAztecCodeGenerator"
        default:
            print("")
            //print("\(barcode.type) not done yet")
        }
        
        return generateCodeFromString(encoding, string: barcode.code)
    }
    
    func generateCodeFromString(type: String, string : String) -> UIImage? {
        let data = string.dataUsingEncoding(NSISOLatin1StringEncoding)
        
        if let filter = CIFilter(name: type) {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransformMakeScale(3, 3)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        return nil
    }
    /*
    //
    //  BarcodeCaroselViewController.swift
    //  brcd
    //
    //  Created by Quintin Balsdon on 2016/01/17.
    //  Copyright © 2016 Balsdon. All rights reserved.
    //
    
    import UIKit
    
    class BarcodeCaroselViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var dataSource: [BarcodeEntity] = []
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = fetchAllBarcodes()
    pageViewController = storyboard?.instantiateViewControllerWithIdentifier("BarcodePageViewController") as! UIPageViewController
    
    pageViewController.dataSource = self
    pageViewController.delegate = self
    
    let startVC = viewControllerAtIndex(0) as BarcodeItemViewController?
    
    if  startVC != nil {
    pageViewController.setViewControllers([startVC!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    pageViewController.view.frame = CGRectMake(10, 110, view.frame.width-20, view.frame.height)
    
    addChildViewController(pageViewController)
    view.addSubview(pageViewController.view)
    pageViewController.didMoveToParentViewController(self)
    }
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - UIPageView
    func viewControllerAtIndex(index: Int) -> BarcodeItemViewController? {
    if (dataSource.count == 0 || index >= dataSource.count) {
    return nil
    }
    
    let vc: BarcodeItemViewController = storyboard?.instantiateViewControllerWithIdentifier("BarcodeItemViewController") as! BarcodeItemViewController
    vc.barcode = dataSource[index]
    vc.index = index
    
    return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    
    let vc = viewController as! BarcodeItemViewController
    var index = vc.index!
    
    if index == 0 || index == NSNotFound {
    return nil
    }
    
    index--
    return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
    let vc = viewController as! BarcodeItemViewController
    var index = vc.index!
    
    if index == NSNotFound {
    return nil
    }
    
    index++
    if index == dataSource.count {
    return nil
    }
    
    return viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return dataSource.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
    }
    }

    */
}
