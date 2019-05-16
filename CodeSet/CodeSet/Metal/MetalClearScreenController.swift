//
//  MetalClearScreenController.swift
//  CodeSet
//
//  Created by LangFZ on 2019/5/16.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit

class MetalTestController: UIViewController {

    //clear
    private lazy var testClear: TestClearMetalView = {
        let testClear = TestClearMetalView.init(frame: CGRect.init(x: 0, y: 50, width: 300, height: 500))
        return testClear
    }()
    //triangle
    private lazy var textTriangle: TestTriangleMetalView = {
        let textTriangle = TestTriangleMetalView.init(frame: CGRect.init(x: frameMath(15), y: kNaviBarH, width: frameMath(300), height: frameMath(500)))
        return textTriangle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        
//        view.addSubview(testClear)
        view.addSubview(textTriangle)
    }
}

