//
//  ViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit


class ViewController: BaseViewController, CarbonTabSwipeNavigationDelegate {
    
        var items = NSArray()
        var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
        //액션버튼
        var actionButton: ActionButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //슬라이드버튼
            self.addSlideMenuButton()
            self.title = "imacMarket"
            items = ["커뮤니티", "갤러리", "협력하기", "개발자모임", "코더모임", "디자이너모임"]
            carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
            carbonTabSwipeNavigation.insertIntoRootViewController(self)
            self.style()
            
            //액션바 
            let twitterImage = UIImage(named: "twitter_icon.png")!
            let plusImage = UIImage(named: "googleplus_icon.png")!
            
            let twitter = ActionButtonItem(title: "Twitter", image: twitterImage)
            twitter.action = { item in print("Twitter...") }
            
            let google = ActionButtonItem(title: "Google Plus", image: plusImage)
            google.action = { item in print("Google Plus...") }
            
            actionButton = ActionButton(attachedToView: self.view, items: [twitter, google])
            actionButton.action = { button in button.toggleMenu() }
            actionButton.setTitle("+", forState: .Normal)
            
            actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
            //END 액션바
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
        func style() {
            let color: UIColor = UIColor(red: 0.0 / 255, green: 0.0 / 255, blue: 0.0 / 255, alpha: 1)
            let color2: UIColor = UIColor(red: 0.0 / 255, green: 0.0 / 255, blue: 0.0 / 255, alpha: 1)
            
            
            self.navigationController!.navigationBar.barTintColor = color
          

            carbonTabSwipeNavigation.setIndicatorColor(color2)
            carbonTabSwipeNavigation.setTabExtraWidth(80)
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 0)
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 1)
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 2)
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 3)
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 4)
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(80, forSegmentAtIndex: 5)
            
            carbonTabSwipeNavigation.setNormalColor(UIColor.blackColor().colorWithAlphaComponent(0.8))
            carbonTabSwipeNavigation.setSelectedColor(color, font: UIFont.boldSystemFontOfSize(14))
            
        }
        
        func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAtIndex index: UInt) -> UIViewController {
            
            switch index {
            case 0:
                return self.storyboard!.instantiateViewControllerWithIdentifier("WebViewViewController") as! WebViewViewController //스토리보드아이디/호출한클래스
            case 1:
                return self.storyboard!.instantiateViewControllerWithIdentifier("WebViewViewController") as! WebViewViewController
            case 2:
                return self.storyboard!.instantiateViewControllerWithIdentifier("WebViewViewController") as! WebViewViewController
            default:
                return self.storyboard!.instantiateViewControllerWithIdentifier("WebViewViewController") as! WebViewViewController
            }
            
        }
        
        func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAtIndex index: UInt) {
            NSLog("Did move at index: %ld", index)
        }
        
}
