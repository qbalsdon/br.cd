//
//  UILoader.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/10.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit

@IBDesignable class UILoader: UIControl {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var view: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        
        view.frame = bounds
        
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "UILoader", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }

}
