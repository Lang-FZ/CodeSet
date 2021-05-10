//
//  TestTriangleShaders.metal
//  CodeSet
//
//  Created by LangFZ on 2019/5/16.
//  Copyright © 2019 LangFZ. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "TestTriangleMetalTMVertex.h"

typedef struct {
    
    float4 position [[position]];
    float4 color;
    
} RasterizerData;


vertex RasterizerData vertexShader(constant TMVertex *vertices [[buffer(TMVertexInputIndexVertices)]], uint vid [[vertex_id]]) {
    
    RasterizerData outVertex;
    
    outVertex.position = vector_float4(vertices[vid].position,0.0,1.0);
    
    outVertex.color = vertices[vid].color;
    
    return outVertex;
}

fragment float4 fragmentShader(RasterizerData inVertex [[stage_in]]) {
    
    return inVertex.color;
}
                                   
