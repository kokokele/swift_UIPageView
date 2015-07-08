//
//  MyPageView.swift
//  Swift_UIPageView
//
//  Created by antz on 15/7/8.
//  Copyright (c) 2015年 antz. All rights reserved.
//

import UIKit

class MyPageView: UIView {
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        render("2.jpg")
    }
    
    func render(url:String)
    {
        let img:UIImageView = UIImageView(image: UIImage(named: url))
        img.frame = CGRect(x: 0, y: 0, width: 310, height: 300)
        self.addSubview(img)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
