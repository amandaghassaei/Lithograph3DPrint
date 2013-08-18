//image to 3d printable heightmap/lithophane
//by Amanda Ghassaei
//May 2013
//http://www.instructables.com/id/3D-Printed-Photograph/

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
*/
//libraries
import processing.opengl.*;
import unlekker.util.*;
import unlekker.modelbuilder.*;
import ec.util.*;


String name = "your_file_name_here";//name of file

//storage for dimensions
int widthRes;
int heightRes;
float widthDim = 5;//width dimension (in inches)
float widthScaled;
float heightScaled;
float zDim = 0.1;//max vertical displacement (in inches)
float thickness = 0.02;//base thickness (in inches)

boolean invert = true;//if true, then white areas are lower than black, if not true white areas are taller

PImage img;//storage for image
float pixeldata[];//storage for pixel array
UVertexList v1,v2,v3,v4;//storage for verticies
UGeometry geo;//storage for stl geometry

void setup(){
  
  img = loadImage(name);//load image
  //get dimensions of image
  widthRes = img.width;
  heightRes =img.height;
  
  size(widthRes,heightRes,P3D);//set dimensions of output
  
  image(img, 0,0);//display image
  loadPixels();//poad pixels into array
  
  pixeldata = new float[widthRes*heightRes];//initialize storage for pixel data
  for(int index=0;index<widthRes*heightRes;index++){
    int getPixelData = pixels[index];//get data from pixels[] array
    pixeldata[index] = getPixelData&255;//convert to greyscale byte (0-255)
  }
  
  
  //initialize storage for stl
  geo = new UGeometry();
  v1 = new UVertexList();
  v2 = new UVertexList();
  v3 = new UVertexList();
  v4 = new UVertexList();
  
  //draw stl
  
  if(invert){
    //draw top
    for(int i=0;i<(heightRes-1);i++){
      v1.reset();
      v2.reset();
      for(int j=0;j<widthRes;j++){
        widthScaled = j/float(widthRes)*widthDim;
        //top layer
        v1.add(widthScaled,i/float(widthRes)*widthDim,(255-pixeldata[widthRes*i+j])*zDim/255+thickness);
        v2.add(widthScaled,(i+1)/float(widthRes)*widthDim,(255-pixeldata[widthRes*(i+1)+j])*zDim/255+thickness);
      }
      geo.quadStrip(v1,v2);
    }
    //draw sides
    v1.reset();
    v2.reset();
    v3.reset();
    v4.reset();
    for(int j=0;j<widthRes;j++){
      widthScaled = j/float(widthRes)*widthDim;
      v1.add(widthScaled,0,(255-pixeldata[j])*zDim/255+thickness);
      v2.add(widthScaled,0,0);
      v3.add(widthScaled,(heightRes-1)/float(widthRes)*widthDim,(255-pixeldata[widthRes*(heightRes-1)+j])*zDim/255+thickness);
      v4.add(widthScaled,(heightRes-1)/float(widthRes)*widthDim,0);
    }
    geo.quadStrip(v2,v1);
    geo.quadStrip(v3,v4);
    //draw sides
    v1.reset();
    v2.reset();
    v3.reset();
    v4.reset();
    for(int i=0;i<heightRes;i++){
      heightScaled = i/float(widthRes)*widthDim;
      v1.add(0,heightScaled,(255-pixeldata[widthRes*i])*zDim/255+thickness);
      v2.add(0,heightScaled,0);
      v3.add((widthRes-1)/float(widthRes)*widthDim,heightScaled,(255-pixeldata[widthRes*(i+1)-1])*zDim/255+thickness);
      v4.add((widthRes-1)/float(widthRes)*widthDim,heightScaled,0);
    }
    geo.quadStrip(v1,v2);
    geo.quadStrip(v4,v3);
  }
  else{
        //draw top
    for(int i=0;i<(heightRes-1);i++){
      v1.reset();
      v2.reset();
      for(int j=0;j<widthRes;j++){
        widthScaled = j/float(widthRes)*widthDim;
        //top layer
        v1.add(widthScaled,i/float(widthRes)*widthDim,(pixeldata[widthRes*i+j])*zDim/255+thickness);
        v2.add(widthScaled,(i+1)/float(widthRes)*widthDim,(pixeldata[widthRes*(i+1)+j])*zDim/255+thickness);
      }
      geo.quadStrip(v1,v2);
    }
    //draw sides
    v1.reset();
    v2.reset();
    v3.reset();
    v4.reset();
    for(int j=0;j<widthRes;j++){
      widthScaled = j/float(widthRes)*widthDim;
      v1.add(widthScaled,0,(pixeldata[j])*zDim/255+thickness);
      v2.add(widthScaled,0,0);
      v3.add(widthScaled,(heightRes-1)/float(widthRes)*widthDim,(pixeldata[widthRes*(heightRes-1)+j])*zDim/255+thickness);
      v4.add(widthScaled,(heightRes-1)/float(widthRes)*widthDim,0);
    }
    geo.quadStrip(v2,v1);
    geo.quadStrip(v3,v4);
    //draw sides
    v1.reset();
    v2.reset();
    v3.reset();
    v4.reset();
    for(int i=0;i<heightRes;i++){
      heightScaled = i/float(widthRes)*widthDim;
      v1.add(0,heightScaled,(pixeldata[widthRes*i])*zDim/255+thickness);
      v2.add(0,heightScaled,0);
      v3.add((widthRes-1)/float(widthRes)*widthDim,heightScaled,(pixeldata[widthRes*(i+1)-1])*zDim/255+thickness);
      v4.add((widthRes-1)/float(widthRes)*widthDim,heightScaled,0);
    }
    geo.quadStrip(v1,v2);
    geo.quadStrip(v4,v3);
  }
    
  
  //draw bottom
  v1.reset();
  v2.reset();
  //add bottom four corners
  v1.add(0,0,0);
  v1.add(0,(heightRes-1)/float(widthRes)*widthDim,0);
  v2.add((widthRes-1)/float(widthRes)*widthDim,0,0);
  v2.add((widthRes-1)/float(widthRes)*widthDim,(heightRes-1)/float(widthRes)*widthDim,0);
  geo.quadStrip(v1,v2);
  
  //change extension of file name
  int dotPos = name.lastIndexOf(".");
  if (dotPos > 0)
    name = name.substring(0, dotPos);

  geo.writeSTL(this,name+".stl");

  exit();
  
  println("Finished");

}

