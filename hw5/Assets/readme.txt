I wrote a depth-based edge detector and a normal-based ambient occlusion approximation.

The edge detector samples the rendered scene's depth buffer in four directions and compares them to the center depth. If the difference is high enough, we color it black.

The ambient occlusion is based on the normals of those same samples, dotted with the central point's normal. I take the average of these normals and then just multiply it with the final color.

I had to use shader model 3 for all the arithmetic I had to do.

These can both only be done as postprocesses because they rely on nearby pixels in the final rendered scene.