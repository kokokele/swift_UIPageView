//
//  ViewController.swift
//  Swift_UIPageView
//
//  Created by antz on 15/7/7.
//  Copyright (c) 2015年 antz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KeleUIPageViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var pageView:KeleUIPageView = KeleUIPageView(frame: self.view.frame)
        pageView.delegate = self
        pageView.render()
        
        self.view.addSubview(pageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func onPageChange(index: Int, pageView: UIView)
    {
        (pageView as! MyPageView).setTxt(String(index))
    }
    
    func getTotalPage() -> Int {
        return 6
    }
    
    func getView() -> UIView {
        return MyPageView(frame: self.view.frame)
    }


}

