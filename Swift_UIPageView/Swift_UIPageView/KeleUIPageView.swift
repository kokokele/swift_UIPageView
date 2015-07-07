//
//  KeleUIPageView.swift
//  Swift_UIPageView
//
//  Created by antz on 15/7/7.
//  Copyright (c) 2015年 antz. All rights reserved.
//

import UIKit

//
//  keleCalMainView.swift
//  KeleCalendar
//
//  Created by antz on 15/6/17.
//  Copyright (c) 2015年 antz. All rights reserved.
//

import UIKit

enum ScrollDirection {
    case None
    case Right
    case Left
}

class KeleUIPageView: UIView, UIScrollViewDelegate {
    
    
    
    var delegate:KeleUIPageViewDelegate?
    
    private let _scrollView: UIScrollView!
    
    private let _frame:CGRect!
    
    
    private var _page:Int = 1
    private var _pageChanged:Bool =  false
    private var _lastContentOffset:CGFloat = 0
    private var _direction: ScrollDirection = .None
    
    private var _viewCache = [KeleUIPageViewDelegate]()
    
    
    
    init() {
        
        var frame = CGRectMake(0, 30, 320, 8 * 320 / 7)
        
        
        _frame = frame
        _scrollView = UIScrollView(frame:frame)
        super.init(frame:frame)
        
        // Setup Scroll View.
        _scrollView.contentSize = CGSizeMake(frame.width * 3, frame.height)
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.frame = CGRectMake(0, 60, frame.width, frame.height)
        _scrollView.pagingEnabled = true
        _scrollView.delegate = self
        
        
        
        addSubview(_scrollView)
        
        
        
        
        
    }
    
    func render()
    {
        self.initUI(_frame)
    }
    
    
    internal func next()
    {
        _pageChanged = true
        _direction = .Left
        fit()
    }
    
    internal func pre()
    {
        _pageChanged = true
        _direction = .Right
        fit()
    }
    
    
    
    //------------------PRIVATE----------------
    
    private func initUI(frame:CGRect)
    {
        
        let bounds = UIScreen.mainScreen().bounds
        
        
        for i in 0...2 {
            let view = delegate?.getView()//(frame: CGRectMake(frame.width * CGFloat(i), 0, frame.width, frame.height))
           // _viewCache[i] = view
            view!.tag = i
            _scrollView.addSubview(view!)
            
            
            if i == 0 {
                
                delegate?.onPageChange(1, pageView: view!)
                
            } else if i == 1 {
                
                delegate?.onPageChange(1, pageView: view!)
            } else {
                
                delegate?.onPageChange(1, pageView: view!)
            }
        }
        
        
        _scrollView.scrollRectToVisible(CGRectMake(frame.width, 0, frame.width, frame.height), animated:false)
        
    }
    
    
  
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
        let width = scrollView.frame.width
        
        let page  = Int(floor((_scrollView.contentOffset.x - width/2) / width) + 1)
        if page !=  _page {
            
            _page = page
            
            if !self._pageChanged {
                
                self._pageChanged = true
                
            } else {
                
                self._pageChanged = false
            }
        }
        
        
        if _scrollView.contentOffset.y != 0 {
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, 0)
        }
        
        if _lastContentOffset > scrollView.contentOffset.x {
            _direction = .Right
        } else if _lastContentOffset < _scrollView.contentOffset.x {
            _direction = .Left
        }
        
        _lastContentOffset = _scrollView.contentOffset.x
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        fit()
        
        //println("scrollViewDidEndDecelerating:\(_pageChanged)")
        
    }
    
    private func fit()
    {
        if _pageChanged{
            
            var temp:KeleUIPageViewDelegate!
            
            //----------------调整容器顺序-------------
            if _direction == .Left {
                
                temp = _viewCache[0]
                _viewCache[0] = _viewCache[1]
                _viewCache[1] = _viewCache[2]
                _viewCache[2] = (temp as? KeleUIPageViewDelegate)!
                
            } else {
                
                temp = _viewCache[2]
                _viewCache[2] = _viewCache[1]
                _viewCache[1] = _viewCache[0]
                _viewCache[0] = (temp as? KeleUIPageViewDelegate)!
                
                
            }
            
            
            
        } else {
            
            
            
        }
        
        self._pageChanged = false
        self._direction = .None
        
    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



