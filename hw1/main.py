from Tkinter import *
from numpy import *

#TKINTER SUCKS
def toColor(rgb):
    r = rgb[0]
    g = rgb[1]
    b = rgb[2]
    result = "#"
    rhex = hex(min(int(round(r)), 255))[2:]
    ghex = hex(min(int(round(g)), 255))[2:]
    bhex = hex(min(int(round(b)), 255))[2:]
    if len(rhex) == 1:
        rhex = "0" + rhex
    if len(ghex) == 1:
        ghex = "0" + ghex
    if len(bhex) == 1:
        bhex = "0" + bhex
    return result + rhex + ghex + bhex

#color stuff
def colorAdd(a, b):
    return [a[0]+ b[0], a[1] + b[1], a[2] + b[2]]

def colorMult(a, b, s=1):
    return [a[0] * b[0] * s, a[1] * b[1] * s, a[2] * b[2] * s]

#numpy normalizer
def normalize(v):
    norm = linalg.norm(v)
    if norm == 0: 
        return v
    return v/norm

#TKINTER SETUP
master = Tk()
canvas = Canvas(master, width=500, height=500, bg="#aa7777")
canvas.pack()

###################################
#NOTES
#x positive to the right
#y positive upwards
#z positive into screen
#rotations clockwise looking in negative direction
#rotations applied X, then Y, then Z
###################################

###################################
#PARAM VARIABLES
filename = "cessna.raw"
lightPos = [50,200,-300]
lightDiffCol = [3,3,3]
lightAmbCol = [2,2,4]
lightSpecCol = [2,2,2]
camPos = [50,60,55]
camLook = [50,60,80]
fov = 90
near = 1
far = 200
objpos = [50,60,80]
objrot = [0,-120,-90]
matAmbCol = [20,20,22]
matSpecCol = [20,70,20]
matDiffCol = [20,30,20]
matEmisCol = [30,50,30]
specularity = 12
###################################
###################################
###################################
###################################
###################################
###################################
###################################
###################################
###################################
###################################
###################################
###################################
###################################
###################################
###################################

#DECLARE MATRICES AND STUFF
rotXmat = array([ [1,0,0,0], [0, cos(deg2rad(objrot[0])), sin(deg2rad(objrot[0])), 0], [0, -sin(deg2rad(objrot[0])), cos(deg2rad(objrot[0])), 0], [0,0,0,1] ])
rotYmat = array([ [cos(deg2rad(objrot[1])), 0, -sin(deg2rad(objrot[1])), 0], [0,1,0,0], [sin(deg2rad(objrot[1])), 0, cos(deg2rad(objrot[1])), 0], [0,0,0,1] ])
rotZmat = array([ [cos(deg2rad(objrot[2])), sin(deg2rad(objrot[2])), 0, 0], [-sin(deg2rad(objrot[2])), cos(deg2rad(objrot[2])), 0, 0], [0,0,1,0], [0,0,0,1] ])
translationMat = array([ [1,0,0,0], [0,1,0,0], [0,0,1,0], [objpos[0], objpos[1], objpos[2], 1] ])

worldTransform = dot(dot(dot(rotXmat, rotYmat), rotZmat), translationMat)

lightPos = array([ lightPos[0], lightPos[1], lightPos[2]])
camPos = array([ camPos[0], camPos[1], camPos[2]])
camLook = array([ camLook[0], camLook[1], camLook[2]])

zaxis = normalize(subtract(camLook, camPos))
xaxis = normalize(cross(array([0,1,0]),zaxis))
yaxis = cross(zaxis, xaxis)
viewTransform = array([
                       [xaxis[0], yaxis[0], zaxis[0], 0],
                       [xaxis[1], yaxis[1], zaxis[1], 0],
                       [xaxis[2], yaxis[2], zaxis[2], 0],
                       [-dot(xaxis, camPos), -dot(yaxis, camPos), -dot(zaxis, camPos), 1]
                       ])

scale = 1/(tan(fov/2.0))
projTransform = array([
                       [scale, 0,0,0],
                       [0,scale,0,0],
                       [0,0,far/float(far-near),1],
                       [0,0,-(near*far)/float(far-near),0]
                       ])

projTransform = dot(viewTransform, projTransform)


#LOAD MODEL
model = []
f = open(filename,'r')
line = f.readline()
while line != "":
    nums = line.split()
    model.append(map(lambda x: float(x), nums))
    line = f.readline()
f.close()

#WORLD TRANSFORMATION
fragments = []
for triangle in model:
    fragment = []
    for x in range(3):
        vec = array([triangle[x*3], triangle[(x*3)+1], triangle[(x*3)+2], 1])
        fragment.append(dot(vec, worldTransform))
    fragments.append(fragment)
    
#COMPUTE COLOR
triangles = []
for fragment in fragments:
    
    #get surface normal
    edge = array([ fragment[1][0] - fragment[0][0], fragment[1][1] - fragment[0][1], fragment[1][2] - fragment[0][2] ])
    edge2 = array([ fragment[2][0] - fragment[0][0], fragment[2][1] - fragment[0][1], fragment[2][2] - fragment[0][2] ])
    fragNorm = normalize(cross(edge, edge2))
    #possibly make negative here
    
    #emissive
    color = matEmisCol
    #ambient
    color = colorAdd(color,colorMult(matAmbCol, lightAmbCol))
    #diffuse calculation
    fragPos = ((fragment[0] + fragment[1] + fragment[2])/3.0)[:3]
    lightVec4D = subtract(lightPos, fragPos) #possible negative
    lightVec = normalize(array([lightVec4D[0], lightVec4D[1], lightVec4D[2]]))
    diffuseScalar = max(dot(lightVec, fragNorm), 0)
    color = colorAdd(color, colorMult(matDiffCol, lightDiffCol, diffuseScalar))
    #specular calculation
    camVec4D = subtract(camPos, fragPos) #possible negative
    camVec = normalize(array([camVec4D[0], camVec4D[1], camVec4D[2]]))
    halfwayVec = normalize(add(camVec, lightVec))
    specScalar = max(dot(fragNorm, halfwayVec), 0)**specularity
    color = colorAdd(color, colorMult(matSpecCol, lightSpecCol, specScalar))
    
    fragment.append(color)
    triangles.append(fragment)

#TRANSFORM TO CAMERA & PERSPECTIVE PROJECTION
viewTriangles = []
for triangle in triangles:
    viewT = []
    for x in range(3):
        newT = dot(triangle[x], projTransform)
        newT = newT/newT[3] #divide by w
        viewT.append(newT)
    viewT.append(triangle[3])
    viewTriangles.append(viewT)

def sorter(x):
    return average([x[0][2], x[1][2], x[2][2]])
viewTriangles.sort(key=sorter, reverse=True)
#print viewTriangles


for triangle in viewTriangles:
    if not (triangle[0][2] < 0 and triangle[1][2] < 0 and triangle[2][2] < 0) or (triangle[0][2] > 1 and triangle[1][2] > 1 and triangle[2][2] > 1):
        ax = (1 + triangle[0][0]) * 250
        ay = 500-(1 + triangle[0][1]) * 250
        bx = (1 + triangle[1][0]) * 250
        by = 500-(1 + triangle[1][1]) * 250
        cx = (1 + triangle[2][0]) * 250
        cy = 500-(1 + triangle[2][1]) * 250
        canvas.create_polygon(map(lambda x: int(round(x)), [ax, ay, bx, by, cx, cy]), fill=toColor(triangle[3]))

        
##DRAW AT END
master.mainloop()

