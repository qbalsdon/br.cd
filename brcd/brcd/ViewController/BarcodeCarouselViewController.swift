//
//  BarcodeCaroselViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/17.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes_Swift

class BarcodeCarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barcodeCarousel: iCarousel!
    var dataSource: [BarcodeEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = fetchAllBarcodes((tabBarController as! GroupTabBarViewController).group)
        
        barcodeCarousel.type = iCarouselType.TimeMachine
        barcodeCarousel.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        barcodeCarousel.currentItemIndex = 0
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
        if (view == nil) {
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:200, height:200))
            itemView.contentMode = .ScaleAspectFit
        }
        else {
            itemView = view as! UIImageView;
        }
        
        itemView.image = generateCode(dataSource[index])
        itemView.backgroundColor = UIColor.whiteColor()
        return itemView
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        if barcodeCarousel.currentItemIndex < 0 || barcodeCarousel.currentItemIndex >= dataSource.count {
            return
        }
        titleLabel.text = dataSource[barcodeCarousel.currentItemIndex].code
        print("We are at \(barcodeCarousel.currentItemIndex): [\(dataSource[barcodeCarousel.currentItemIndex].code)] type: [\(dataSource[barcodeCarousel.currentItemIndex].type)]")
    }
    
    // MARK: - Render codes
    func generateCode(barcode: BarcodeEntity) -> UIImage? {

        if let image = RSUnifiedCodeGenerator.shared.generateCode(barcode.code, machineReadableCodeObjectType: barcode.type) {
            return RSAbstractCodeGenerator.resizeImage(image, scale: 3.0)
        }
        return nil
    }
}
