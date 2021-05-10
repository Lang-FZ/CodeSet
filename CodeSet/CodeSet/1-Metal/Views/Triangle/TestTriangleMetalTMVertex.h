//
//  TestTriangleMetalTMVertex.h
//  CodeSet
//
//  Created by LangFZ on 2019/5/16.
//  Copyright © 2019 LangFZ. All rights reserved.
//

#ifndef TestTriangleMetalTMVertex_h
#define TestTriangleMetalTMVertex_h

#import <simd/simd.h>

typedef struct {
    
    vector_float2 position;
    vector_float4 color;
    
} TMVertex;

typedef enum TMVertextInputIndex {
    
    TMVertexInputIndexVertices = 0,
    TMVertexInputIndexCount = 1
    
} TMVertextInputIndex;

#endif /* TestTriangleMetalTMVertex_h */
