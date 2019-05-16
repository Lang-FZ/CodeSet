//
//  TestBufferTextureShaders.metal
//  CodeSet
//
//  Created by LangFZ on 2019/5/16.
//  Copyright © 2019 LangFZ. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "TestBufferTextureMetalTMVertex.h"

typedef struct {
    
    float4 position [[position]];
    float2 texCoords;
    
} RasterizerData_texture;


vertex RasterizerData_texture vertexShader(constant TMVertex_texture *vertices [[buffer(TMVertexInputIndexVertices_texture)]], uint vid [[vertex_id]]) {
    
    RasterizerData_texture outVertex;
    
    outVertex.position = vector_float4(vertices[vid].position,0.0,1.0);
    outVertex.texCoords = vertices[vid].textureCoordinate;
    
    return outVertex;
}

fragment float4 fragmentShader(RasterizerData_texture inVertex [[stage_in]], texture2d<float> tex2d [[texture(TMVertexIndexBaseColor_texture)]]) {
    
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
    
    return float4(tex2d.sample(textureSampler, inVertex.texCoords));
}
