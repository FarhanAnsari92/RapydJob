//
//  ReachabilityHelper.swift
//  eGrocery
//
//  Created by Shoaib on 3/27/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//
//
import UIKit
import Alamofire

public var REACHABILITY_HELPER:ReachabilityHelper {
    get {
        return ReachabilityHelper.sharedInstance;
    }
} //P.E.
/// GISTApplication protocol to receive events
@objc public protocol ReachabilityDelegate {
    @objc optional func reachabilityDidUpdate(_ status: Bool);
} //F.E.
public class ReachabilityHelper: NSObject {
    
    fileprivate var _window: UIWindow!
    
    static var sharedInstance: ReachabilityHelper = ReachabilityHelper();
    
    fileprivate var _reachability:NetworkReachabilityManager?;
    
    fileprivate var _internetConnected:Bool = false;
    public var internetConnected:Bool {
        get {
            return _internetConnected;
        }
        
        set {
            _internetConnected = newValue;
            self.internetConnectionLabelHidden = _internetConnected;
        }
    } //P.E.
    
    //Public Method
    public var isInternetConnected:Bool {
        get {
            if (self.internetConnectionLabelHidden != _internetConnected) {
                self.internetConnectionLabelHidden = _internetConnected;
            } else if (_internetConnected == false) {
                self.internetConnectionLbl.shake();
            }
            
            return _internetConnected;
        }
    } //P.E.
    
    fileprivate var _internetConnectionLbl:UIButton!;
    fileprivate var internetConnectionLbl:UIButton {
        get {
            
            if (_internetConnectionLbl == nil) {
                let statusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height;
                let btnSize:CGSize = CGSize(width: UIScreen.main.bounds.width, height: 44 + statusBarHeight);
                
                _internetConnectionLbl = UIButton();
                _internetConnectionLbl.frame = CGRect(x: 0, y: -btnSize.height, width: btnSize.width, height: btnSize.height);
                
                _internetConnectionLbl.titleEdgeInsets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0);
                
                _internetConnectionLbl.setTitle("No Internet Connection", for: UIControl.State.normal);
                _internetConnectionLbl.setTitleColor(UIColor.white, for: UIControl.State.normal);
                
                _internetConnectionLbl.backgroundColor = UIColor.gray;
                
                _internetConnectionLbl.titleLabel?.font = .systemFont(ofSize: 14.0)
                
                //Adding Target
                _internetConnectionLbl.addTarget(self, action: #selector(ReachabilityHelper.internetConnectionLabelTapHandler(_:)) , for: UIControl.Event.touchUpInside)
                
                _window.addSubview(_internetConnectionLbl);
            }
            
            return _internetConnectionLbl;
        }
    } //P.E.
    
    fileprivate var _internetConnectionLabelHidden:Bool!;
    fileprivate var internetConnectionLabelHidden:Bool {
        
        set {
            if (_internetConnectionLabelHidden != newValue)
            {
                _internetConnectionLabelHidden = newValue;
                
                var newFrame = self.internetConnectionLbl.frame;
                
                if (_internetConnectionLabelHidden == true) {
                    newFrame.origin.y = -(44 + UIApplication.shared.statusBarFrame.height);
                } else {
                    newFrame.origin.y = 0;
                    
                    //_window.bringSubviewToFront(self.internetConnectionLbl);
                    _window.bringSubview(toFront: self.internetConnectionLbl);
                }
                
                UIView.animate(withDuration: 0.35, animations: { () -> Void in
                    self.internetConnectionLbl.frame = newFrame;
                });
            }
        }
        
        get {
            return (_internetConnectionLabelHidden == nil) ?true:_internetConnectionLabelHidden;
        }
    } //P.E.
    
    /// Holding a collection fo weak delegate instances
    private var _delegates:NSHashTable<ReachabilityDelegate> = NSHashTable();
    
    //MARK: - setupReachability
    public func setupReachability(_ window: UIWindow!) {
        _window = window;
        
        _reachability = NetworkReachabilityManager(host: "www.apple.com") // NetworkReachabilityManager();
        
        if (_reachability?.isReachableOnEthernetOrWiFi)! {
            self.internetConnected = true
        } else {
            self.internetConnected = false
        }
        
        _reachability!.startListening();
        _reachability!.listener = { [unowned self] status in
            
            switch status {
            case .notReachable:
                //Show error state
                self.internetConnected = false;
                break;
            case .reachable(_), .unknown:
                //Hide error state
                self.internetConnected = true;
                break;
            }
            
            //Calling Delegate Methods
            let enumerator:NSEnumerator = self._delegates.objectEnumerator();
            
            while let wTarget:ReachabilityDelegate = enumerator.nextObject() as? ReachabilityDelegate {
                wTarget.reachabilityDidUpdate?(self.internetConnected)
            }
            
        }
        //_reachability!.listener = self.reachabilityUpdate;
        
    } //F.E.
    
    
    func reachabilityUpdate(_ status:NetworkReachabilityManager.NetworkReachabilityStatus) {
        print("status : \(status)")
        
        switch status {
        case .notReachable:
            //Show error state
            self.internetConnected = false;
            break;
        case .reachable(_), .unknown:
            //Hide error state
            self.internetConnected = true;
            break;
        }
        
        //Calling Delegate Methods
        let enumerator:NSEnumerator = self._delegates.objectEnumerator();
        
        while let wTarget:ReachabilityDelegate = enumerator.nextObject() as? ReachabilityDelegate {
            wTarget.reachabilityDidUpdate?(self.internetConnected)
        }
        
    } //F.E.
    
    @objc func internetConnectionLabelTapHandler(_ btn:AnyObject) {
        self.internetConnectionLabelHidden = true;
    } //F.E.
    
    /**
     Registers delegate targets.
     It may register multiple targets.
     */
    public func registerDelegate(_ target:ReachabilityDelegate) {
        if self.weakDelegateForTarget(target) == nil {
            //Adding if not added
            _delegates.add(target)
        }
    } //F.E.
    
    /**
     Unregisters a delegate target.
     It should be called when, the target does not want to reveice application events.
     */
    public func unregisterDelegate(_ target:ReachabilityDelegate) {
        if let wTarget:ReachabilityDelegate = self.weakDelegateForTarget(target) {
            _delegates.remove(wTarget);
        }
    } //F.E.
    
    /// Retrieving weak instance of a given target
    ///
    /// - Parameter target: GISTApplicationDelegate
    /// - Returns: an optional weak target of a target (e.g. Weak<GISTApplicationDelegate>?).
    private func weakDelegateForTarget(_ target:ReachabilityDelegate) -> ReachabilityDelegate?{
        
        let instances = _delegates.allObjects;
        
        for i:Int in 0 ..< instances.count {
            let wTarget:ReachabilityDelegate = instances[i];
            if (wTarget == nil) {
                //Removing if lost target already
                _delegates.remove(wTarget);
            } else if ((target as AnyObject).isEqual(wTarget)) {
                return wTarget;
            }
        }
        
        return nil;
    } //F.E.
    
} //CLS END

extension UIView {
    
    public func shake() {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position");
        shake.duration = 0.1;
        shake.repeatCount = 2;
        shake.autoreverses = true;
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y));
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y));
        self.layer.add(shake, forKey: "position");
    } //F.E.
}
