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
    private var _pageFlag:Int = 0
    private var _pageChanged:Bool =  false
    private var _lastContentOffset:CGFloat = 0
    private var _direction: ScrollDirection = .None
    
    private var _viewCache:[UIView]! = Array()
    
    
    private var _startX:CGFloat = 0.0
    
    
    
    override init(frame: CGRect) {

        
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
        
        
        for i in 0...2
        {
            let view = delegate?.getView()
            let frame =  CGRectMake(frame.width * CGFloat(i), 0, frame.width, frame.height)
            view?.frame  = frame
            _viewCache.append(view!)
            
            view?.tag = i
            _scrollView.addSubview(view!)
            
        }
        
        delegate?.onPageChange(2, pageView: _viewCache[1])
        
        
        //_scrollView.scrollRectToVisible(CGRectMake(frame.width, 0, frame.width, frame.height), animated:false)
        
    }
    
    
  
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        _startX = _scrollView.contentOffset.x

        let width = scrollView.frame.width
        
        let pageFlag  = Int(floor((_scrollView.contentOffset.x - width/2) / width) )
        
        println(pageFlag)
        if pageFlag !=  _pageFlag {
            
            _pageFlag = pageFlag
            
            if !self._pageChanged {
                
                self._pageChanged = true
                
            } else {
                
                self._pageChanged = false
            }
        }
//
        
        
        
        
        if _scrollView.contentOffset.y != 0 {
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, 0)
        }
        
        //println("\(_lastContentOffset):\(_scrollView.contentOffset.x)")
        
        if _lastContentOffset > scrollView.contentOffset.x {
            _direction = .Right
        } else if _lastContentOffset < _scrollView.contentOffset.x {
            _direction = .Left
        }
        
        
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
//        println("scrollViewWillBeginDragging:", Int(_scrollView.contentOffset.x))
        
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
//        println("scrollViewWillEndDragging:")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        //println("scrollViewDidEndDragging:")
        
//        let width = scrollView.frame.width
//
//        let ox = _scrollView.contentOffset.x
        
        
//        println("\(ox), \(abs(ox  - _startX)), \(width / 5)")
//        
//        if  Int(abs(ox  - _startX)) > Int((width / 5))
//        {
//            _pageChanged = true
//        }
//        _pageChanged = true

    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        println("scrollViewDidEndDecelerating:\(_pageChanged):", Int(_scrollView.contentOffset.x))
        
        //_pageChanged = (_startX != _scrollView.contentOffset.x)
        
        println("_pagecheande:\(_pageChanged)")
        
        fit()
        
        
        
    }
    
    private func fit()
    {
        let total:Int! = delegate?.getTotalPage()

        
        if _pageChanged
        {
            
            var temp:UIView!
            //----------------调整容器顺序-------------
            if _direction == .Left {
                
               

                if _page < total  {
                    
                    _page++
                    
                    if _page != total {
                        
                        if _page == 2
                        {
                            delegate?.onPageChange(3, pageView: _viewCache[2])
                        } else {
                            temp = _viewCache[0]
                            _viewCache[0] = _viewCache[1]
                            _viewCache[1] = _viewCache[2]
                            _viewCache[2] = temp
                            
                            delegate?.onPageChange(_page + 1, pageView: _viewCache[2])
                            resetFrame()
                        }
                       
                    }
                    
                    
                }
                
                
            } else {
                
                
                if _page > 1 {
                    _page--
                    
                    if _page != 1 && _page != total - 1
                    {
                        println("___\(_page)__)")
                        temp = _viewCache[2]
                        _viewCache[2] = _viewCache[1]
                        _viewCache[1] = _viewCache[0]
                        _viewCache[0] = temp
                        
                        delegate?.onPageChange(_page - 1, pageView: _viewCache[0])

                        resetFrame()
                        
                    }
                    
                    
                }
                

                
                
                
                
            }
            
            
            
        }
        self._direction = .None
        
        _lastContentOffset = _scrollView.contentOffset.x
        
        println("page\(_page)", Int(_scrollView.contentOffset.x))
        println("-----------------------")
        
        _pageChanged = false
        
        println("startX:\(_startX)")

        
        
    }
    
    private func resetFrame()
    {
        for i in 0...2
        {
            
            let frame = CGRectMake(_frame.width * CGFloat(i), 0, _frame.width, _frame.height)
            
            let view:UIView = _viewCache[i]
            view.frame = frame
        }
        
        _scrollView.scrollRectToVisible(CGRectMake(frame.width, 0, frame.width, frame.height), animated:false)
        
        


    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



