//
//  ViewController.swift
//  淘宝轮播
//
//  Created by Cheer on 16/9/23.
//  Copyright © 2016年 joekoe. All rights reserved.
//

import UIKit


class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let (v,success) = CarouselView.create(CGRectMake(0, 0, view.frame.width, 100), dataSource: ["1","2","3","4","5"])
        
        success ? view.addSubview(v) : fatalError()

    }

}


