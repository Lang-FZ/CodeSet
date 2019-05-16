//
//  TestClearMetalView.swift
//  CodeSet
//
//  Created by LangFZ on 2019/5/16.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class TestClearMetalView: UIView {
    
    /** 属性 */
    
    override class var layerClass:AnyClass {
        return CAMetalLayer.self
    }
    
    private var metalLayer:CAMetalLayer {
        return layer as! CAMetalLayer
    }
    private var device:MTLDevice {
        var device:MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        return device
    }
    
    
    // MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    private func commonInit() {
        metalLayer.device = device
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
    private func render() {
        
        guard let drawable = metalLayer.nextDrawable() else {
            return
        }
        
        let renderPassDescripor = MTLRenderPassDescriptor.init()
        renderPassDescripor.colorAttachments[0].clearColor = MTLClearColorMake(0, 190/255.0, 220/255.0, 1)
        renderPassDescripor.colorAttachments[0].texture = drawable.texture
        renderPassDescripor.colorAttachments[0].loadAction = .clear
        renderPassDescripor.colorAttachments[0].storeAction = .store
        
        var commonQueue:MTLCommandQueue!
        commonQueue = device.makeCommandQueue()
        
        let commandBuffer = commonQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescripor)
        commandEncoder?.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deini_TestClearMetalView")
    }
}
