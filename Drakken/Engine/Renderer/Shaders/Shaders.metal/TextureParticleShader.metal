//
//  FluidShader.metal
//  Underground_Survivors
//
//  Created by Allison Lindner on 23/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

constant float kWorldScale = 160.0;

struct VertexOut
{
	float4 position		[[ position ]];
	float3 normal		[[ user(normal) ]];
	float2 texcoord		[[ user(tex_coord) ]];
	float4 color		[[ user(color) ]];
	float  pointSize	[[ point_size ]];
};

struct SharedUniforms
{
	float4x4 projectionMatrix;
	float4x4 viewProjection;
};

struct ModelUniforms
{
	float4x4 modelMatrix;
};

struct Material {
	float specularIntensity;
	float shininess;
};

struct Light
{
	float3 color;
	float ambientIntensity;
	float diffuseIntensity;
	float3 direction;
};

vertex VertexOut texture_particle_vertex ( 	constant	SharedUniforms	&sharedUniforms		[[ buffer(0) ]],
											constant	ModelUniforms	&modelUniforms		[[ buffer(1) ]],
											constant	float2			*particlePositions	[[ buffer(2) ]],
											constant	float			&pointSize			[[ buffer(3) ]],
											uint						vid					[[ vertex_id ]])
{
	VertexOut v_out;
	
	v_out.position =	sharedUniforms.projectionMatrix *
						sharedUniforms.viewProjection *
						modelUniforms.modelMatrix *
						float4(particlePositions[vid].x * kWorldScale, particlePositions[vid].y * kWorldScale, 0.0, 1.0);
	
	v_out.pointSize = pointSize * 0.95;
	
	return v_out;
}

fragment float4 texture_particle_fragment (	texture2d<float>	texture1	[[ texture(0) ]],
										 	sampler				s			[[ sampler(0) ]],
										 	float2				pointCoord	[[ point_coord ]])
{
	float4 color = texture1.sample(s, pointCoord);
	if(color.a == 0) {
		discard_fragment();
	}
	
	return color;
}