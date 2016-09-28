//
//  CarouselView.swift
//  淘宝轮播
//
//  Created by Cheer on 16/9/23.
//  Copyright © 2016年 joekoe. All rights reserved.
//

import UIKit

protocol CarouselViewInit
{
    static func create(frame:CGRect,dataSource:[String])-> (UIView,Bool)
}


class CarouselView: UIView,CarouselViewInit
{
    internal var dataSource:[String]!
    {
        didSet
        {
            var tempArr  = [UIImage]()
            
            for str in dataSource
            {
                tempArr.append(UIImage(named: str) ?? UIImage())
            }
            
            imageArr = tempArr
            
        }
    }
    
    private var imageArr:[UIImage]!
    {
        didSet
        {
            if imageArr.count > 1
            {
                topImage.image = imageArr.first
                nextImage.image = imageArr[1]
            }
            else
            {
                fatalError("图片没有一张以上怎么轮播！")
            }
        }
    }
    
    private var timer:NSTimer!
    
    private lazy var swipLeftGesture:UISwipeGestureRecognizer =
    {
        let ges = UISwipeGestureRecognizer(target: self, action: #selector(CarouselView.handleSwipe(_:)))
        ges.direction = .Left
        return ges
    }()
    private lazy var swipRightGesture:UISwipeGestureRecognizer =
        {
            let ges = UISwipeGestureRecognizer(target: self, action: #selector(CarouselView.handleSwipe(_:)))
            ges.direction = .Right
            return ges
    }()
    
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var topImage: UIImageView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        timer = NSTimer(timeInterval: 2.5, target: self, selector: #selector(CarouselView.handleTimer), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        addGestureRecognizer(swipRightGesture)
        addGestureRecognizer(swipLeftGesture)
    }
    
//    ///从左向右
//    @objc private func left2Right()
//    {
//        
//        /*先换图*/
//        nextImage.image = topImage.image
//        
//        if let index = imageArr.indexOf(topImage.image!) where index < imageArr.count
//        {
//            //next是最后一张，否则数组越界
//            topImage.image = index == 0 ? imageArr[imageArr.count - 1] : imageArr[index - 1]
//        }
//        
//        /*再动画*/
//       
//        nextImage.layer.transform = CATransform3DConcat(CATransform3DMakeRotation(CGFloat(M_PI) / 4, 0, 1, 0), CATransform3DMakeTranslation(-200, 0, 0))
//        
//        UIView.animateKeyframesWithDuration(0.7, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: {
//            
//            let temp = CATransform3DConcat(CATransform3DMakeRotation(-CGFloat(M_PI) / 6, 0, 1, 0), CATransform3DMakeTranslation(200, 0, 0))
//            var scale = CATransform3DIdentity;
//            scale.m34 = -1.0 / 500;
//            
//            self.topImage.layer.transform = CATransform3DConcat(temp,scale)
//            self.nextImage.layer.transform = CATransform3DIdentity
//            
//        }) { (_) in
//            
//            self.topImage.layer.transform = CATransform3DIdentity
//        }
//    }
//    
//    
//    @objc private func right2Left()
//    {
//        /*先换图*/
//        topImage.image = nextImage.image
//        
//        if let index = imageArr.indexOf(nextImage.image!) where index < imageArr.count
//        {
//            //next是最后一张，否则数组越界
//            nextImage.image = index == imageArr.count - 1 ? imageArr[0] : imageArr[index + 1]
//        }
//        
//        /*再动画*/
//        nextImage.layer.transform = CATransform3DConcat(CATransform3DMakeRotation(-CGFloat(M_PI) / 4, 0, 1, 0), CATransform3DMakeTranslation(200, 0, 0))
//        
//        UIView.animateKeyframesWithDuration(0.7, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: {
//            
//            let temp = CATransform3DConcat(CATransform3DMakeRotation(CGFloat(M_PI) / 6, 0, 1, 0), CATransform3DMakeTranslation(-200, 0, 0))
//            var scale = CATransform3DIdentity;
//            scale.m34 = -1.0 / 500;
//            
//            self.topImage.layer.transform = CATransform3DConcat(temp,scale)
//            self.nextImage.layer.transform = CATransform3DIdentity
//            
//        }) { (_) in
//            
//            self.topImage.layer.transform = CATransform3DIdentity
//        }
//    }
    @objc private func handleTimer()
    {
        animate(true)
    }
    
    private func animate(isLeft:Bool)
    {
        /*先换图*/
        isLeft ? topImage.image = nextImage.image : (nextImage.image = topImage.image)
        
        
        if let index = imageArr.indexOf(isLeft ? nextImage.image! : topImage.image!) where index < imageArr.count
        {
            //next是最后一张，否则数组越界
            if isLeft
            {
                nextImage.image = index == imageArr.count - 1 ? imageArr[0] : imageArr[index + 1]
            }
            else
            {
                topImage.image = index == 0 ? imageArr[imageArr.count - 1] : imageArr[index - 1]
            }
        }
        
        /*再动画*/
        var angle = -CGFloat(M_PI) / 4
        let distance = CGFloat(200)
        
        nextImage.layer.transform = CATransform3DConcat(CATransform3DMakeRotation(isLeft ? angle : -angle, 0, 1, 0), CATransform3DMakeTranslation(isLeft ? distance : -distance, 0, 0))
        
        UIView.animateKeyframesWithDuration(0.7, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: {
            
            angle = CGFloat(M_PI) / 6
            
            let temp = CATransform3DConcat(CATransform3DMakeRotation(isLeft ? angle : -angle, 0, 1, 0), CATransform3DMakeTranslation(isLeft ? -distance : distance, 0, 0))
            var scale = CATransform3DIdentity;
            scale.m34 = -1.0 / 500;
            
            self.topImage.layer.transform = CATransform3DConcat(temp,scale)
            self.nextImage.layer.transform = CATransform3DIdentity
            
        }) { (_) in
            
            self.topImage.layer.transform = CATransform3DIdentity
        }
        
    }
}


extension CarouselView
{
    class func create(frame:CGRect,dataSource:[String])-> (UIView,Bool)
    {
        if let view = UINib(nibName: "CarouselView", bundle: nil).instantiateWithOwner(nil, options: nil).first as? CarouselView
        {
            view.dataSource = dataSource
            view.frame = frame
            
            return (view,true)
        }
        return (UIView(),false)
    }
}

extension CarouselView
{
    @objc private func handleSwipe(sender:UISwipeGestureRecognizer)
    {
        timer.fireDate = .distantFuture()
        
        switch sender.state
        {
        case .Ended:
            
            animate(sender.direction == .Left)
            
        default: break
        }
        
        timer.fireDate = .distantPast()
    }
    
}

