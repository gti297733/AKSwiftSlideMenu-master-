//
//  WebViewViewController.swift
//  AKSwiftSlideMenu
//
//  Created by sangmin lee on 2016. 4. 10..
//  Copyright © 2016년 Kode. All rights reserved.
//


    import UIKit
    import WebKit
    

class WebViewViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var webView: WKWebView
    
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var active: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
        
        self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        view.insertSubview(webView, belowSubview: progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        let url = NSURL(string:"http://barojava.com/app/web/loadmore/index.php")
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        addRefreshControl()
        
        //얼렛창 출력 선언해줘야함 .
        self.webView.UIDelegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pullToRefresh() {
        self.refreshControl.endRefreshing()
        self.webView.reload()
    }
    
    func addRefreshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "당겼다 새로고침...")
        refreshControl.addTarget(self, action: #selector(WebViewViewController.pullToRefresh), forControlEvents:.ValueChanged)
        self.webView.scrollView.addSubview(refreshControl)
    }
    
    
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        
        if (keyPath == "estimatedProgress") {
            //progressView.setProgress(0.0, animated: false)
            let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spiningActivity.labelText = "Loging..."
            
            
            
            progressView.hidden = true //프로그래스바 안보이게
            
        }
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    
}


//자바스크립트 기본 얼렛창->WKWEBview는 기본 얼렛을 처리해줘야함.
private typealias wkUIDelegate =  WebViewViewController
extension wkUIDelegate {
    
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (aa) -> Void in
            completionHandler()
        }))
        self.presentViewController(ac, animated: true, completion: nil)
    }
}
