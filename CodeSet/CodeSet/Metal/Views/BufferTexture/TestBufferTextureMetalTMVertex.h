//
//  TestBufferTextureMetalTMVertex.h
//  CodeSet
//
//  Created by LangFZ on 2019/5/16.
//  Copyright © 2019 LangFZ. All rights reserved.
//

#ifndef TestBufferTextureMetalTMVertex_h
#define TestBufferTextureMetalTMVertex_h

#import <simd/simd.h>

typedef struct {
    
    vector_float2 position;
    vector_float2 textureCoordinate;
    
} TMVertex_texture;

typedef enum TMVertextInputIndex_texture {
    
    TMVertexInputIndexVertices_texture = 0,
    TMVertexInputIndexCount_texture = 1
    
} TMVertextInputIndex_texture;

typedef enum TMVertextIndex_texture {
    
    TMVertexIndexBaseColor_texture = 0,
    
} TMVertextIndex_texture;

#endif /* TestBufferTextureMetalTMVertex_h */
