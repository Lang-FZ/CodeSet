//
//  TestBufferTextureMetalView.swift
//  CodeSet
//
//  Created by LangFZ on 2019/5/16.
//  Copyright © 2019 LangFZ. All rights reserved.
//

import UIKit

class TestBufferTextureMetalView: UIView {
    
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
            library = try device.makeLibrary(filepath: Bundle.main.path(forResource: "TestBufferTextureShaders", ofType: "metal") ?? "")
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
    private lazy var vertexBuffer:MTLBuffer = {
        
        let vertices = [
            TMVertex_texture.init(position: [-1.0,-1.0], textureCoordinate: [0,1]),
            TMVertex_texture.init(position: [-1.0,1.0], textureCoordinate: [0,0]),
            TMVertex_texture.init(position: [1.0,-1.0], textureCoordinate: [1,1]),
            TMVertex_texture.init(position: [1.0,1.0], textureCoordinate: [1,0])
        ]
        
        let vertexBuffer = self.device.makeBuffer(bytes: vertices, length: MemoryLayout<TMVertex_texture>.size * vertices.count, options: MTLResourceOptions.cpuCacheModeWriteCombined)!
        
        return vertexBuffer
    }()
    private lazy var texture:MTLTexture = {
       
        let image = UIImage.init(named: "lena")!
        
        let imageRef = image.cgImage!
        let width = imageRef.width
        let height = imageRef.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = calloc(height * width * 4, MemoryLayout<UInt8>.size)
        let bytesPerPixel:Int = 4
        let bytesPerRow:Int = bytesPerPixel * width
        let bitsPerComponent:Int = 8
        let bitmapContext = CGContext.init(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        
        bitmapContext?.draw(imageRef, in: CGRect.init(x: 0, y: 0, width: CGFloat.init(width), height: CGFloat.init(height)))
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.rgba8Unorm, width: width, height: height, mipmapped: false)
        
        let texture:MTLTexture = device.makeTexture(descriptor: textureDescriptor)!
        
        let region:MTLRegion = MTLRegionMake2D(0, 0, width, height)
        texture.replace(region: region, mipmapLevel: 0, withBytes: rawData!, bytesPerRow: bytesPerRow)
        
        free(rawData)
        
        return texture
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
        
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.setFragmentTexture(texture, index: 0)
        commandEncoder?.drawPrimitives(type: MTLPrimitiveType.triangleStrip, vertexStart: 0, vertexCount: 4)
        
        commandEncoder?.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deini_TestBufferTextureMetalView")
    }
}
