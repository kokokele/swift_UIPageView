//
//  KeleUIPageViewDelegate.swift
//  Swift_UIPageView
//
//  Created by antz on 15/7/7.
//  Copyright (c) 2015年 antz. All rights reserved.
//

import UIKit


protocol KeleUIPageViewDelegate{
    
    func getView()->UIView
    
    func getTotalPage()->Int
    
    func onPageChange(index:Int, pageView:UIView)
    
}
