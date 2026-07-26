shader_type canvas_item;
//2D 一般都用 canvas_item

uniform float lerp_percent : hint_range(0.0, 1.0);
//uniform means that the value can be setted outside the shader
//右侧检查器，下滑到material--shader--shader parameter，就可以看到lero percent已经有了
//hint_range(0.0, 1.0, 0.1) 设置区间，0.1是步长
//完成后保存shader，material的小箭头调开保存

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_color = texture(TEXTURE, UV);
	// 从纹理中采样当前像素的颜色（TEXTURE是贴图上每一个像素，UV是对应像素的坐标from (0,0) to (1,1)）,
	// vec4: 颜色是 Red Green Blue Alpha组成的
	// vec4是类型，texture_color是自定义的变量
	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a),lerp_percent);
	//mix from texture_color to white(vec4(1.0, 1.0, 1.0, texture_color.a))
	//texture.a 一定要写上，不然就不只是贴图变白，整个正方形区域都变白了
	//最后一个值是白色强度，1.0是全白，0.5是白一半
	COLOR = final_color;
	// 把采样到的颜色输出到屏幕上
}






void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
