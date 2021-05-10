//
//  TestTriangleMetalView.swift
//  CodeSet
//
//  Created by LangFZ on 2019/5/16.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit
import Metal
import QuartzCore
import simd

class TestTriangleMetalView: UIView {
    
    /** 属性 */
    
    override class var layerClass:AnyClass {
        return CAMetalLayer.self
    }
    
    private lazy var metalLayer:CAMetalLayer = {
        return layer as! CAMetalLayer
    }()
    private lazy var device:MTLDevice = {
        var device:MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        return device
    }()
    private lazy var pipelineState:MTLRenderPipelineState = {
        
        var pipelineState:MTLRenderPipelineState!
        var library:MTLLibrary!
        
        do {
            library = try device.makeLibrary(filepath: Bundle.main.path(forResource: "TestTriangleShaders", ofType: "metal") ?? "")
        } catch {
            library = device.makeDefaultLibrary()!
        }
        let vertexFunction = library.makeFunction(name: "vertexShader")
        let fragmentFunction = library.makeFunction(name: "fragmentShader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor.init()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        return pipelineState
    }()
    
    
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
        commandEncoder?.setRenderPipelineState(pipelineState)
        
        let vertices = [
            TMVertex.init(position: [0.5,-0.5], color: [1,0,0,1]),
            TMVertex.init(position: [-0.5,-0.5], color: [0,1,0,1]),
            TMVertex.init(position: [0.5,0.5], color: [0,0,1,1])
        ]
        
        commandEncoder?.setVertexBytes(vertices, length: MemoryLayout<TMVertex>.size * 3, index: Int.init(TMVertexInputIndexVertices.rawValue))
        commandEncoder?.drawPrimitives(type: MTLPrimitiveType.triangle, vertexStart: 0, vertexCount: 3)
        
        commandEncoder?.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deini_TestTriangleMetalView")
    }
}

