I was primarily inspired by the cool banded thing 
you did in class. Otherwise I just came up with stuff.

I made a hybrid diffuse/specular (mostly diffuse 
with a power) that had a kind of range of values it 
could light to as the base lighting.

For the sparkles, I created a texture of random 
grayscale values in Processing, then used it as 
a source of random information. I used some pseudo-
specular power stuff (based on view direction not
light direction) and thresholding to determine
which pixels were going to be in the albedo and
therefore be sparkles (all others were just .5, .5, .5)
I then colored those with a lerp of some color values.

I ran into trouble with exceeding my arithmetic limit
so I had to encode the view direction dot the normal in 
surface output's Alpha so I didn't have to calculate it
again.