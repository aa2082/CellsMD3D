# Biofilm Agent Based Model
---
## how to compile and run the C++ code
### compile the code
```
cd run_sim
g++ ../*.cpp -fopenmp -O3
```
### run the code
`./a.out in1.txt 2 /Directory/To/Output/Folder > /Redirect/Console/Output &`

list of arguments:

The command line argument `in1.txt` is the input txt file.\
The command line argument `2` means we run this code using 2 cores. You can change it to some other numbers.\
The command line argument `/Directory/To/Output/Folder` is the directory to output the data.\
The command line argument `> /Redirect/Console/Output &` means console output gets redirected
to `/Redirect/Console/Output`, and the program runs in background.

***
## Memory
don't blow up the memory\
If you run the code in a local machine, and you don't want to take up too much memory,\
you need to set the variable `MaxCells` to be small, say 100000. If you set it to be 3 millions, then it might take up a lot of memory.
To adjust MaxCells, you just go to `in1.txt`, and change the integer number that is next to `MaxCells`.

---

how is the data output?
We have a global variable DirName (Defined in Constants.h), which takes in the 4th command line argument. The output is stored in the path given by DirName.
Under the DirName, there will be folders as the following:
```
AgarField     Density       Density2      Height  Restart       RoughDensity1  WallDensity   WallDensity2  lineage
Cells         Density1      Environment   Normal  RoughDensity  RoughDensity2  WallDensity1  WallField
```
In each folder, there will be text files storing information related to the folder name, where the name of the text file. such as `11.txt`, represents the time point the text file is storing data for
***
## how to visualize the output data
We visualize the data using MATLAB, and in this section, we will write MATLAB commands:

You can load the data by something like the following:
```Matlab
dir_cells='/Direcotry/To/Output/Folder';
i_cells=250;
cells=load(sprintf('%s/Cells/%d.txt',dir_cells,i_cells));
```
You can find out the indices of the cells whose center of mass has height less than 2um by the following command:
```Matlab
dh = 2;
i_btm = find((cells(:,6)+cells(:,9))/2<dh);
```
You can find out the indices of cells whose center of mass has height less than 2um, with type 1 and type 2 by the following command:
```Matlab
i1 = find(cells(i_btm,3)==1);
i2 = find(cells(i_btm,3)==2);
```
You can plot all such cells with stick representation and different color by the following command:
```Matlab
quiver3(cells(i_btm(i1),4), cells(i_btm(i1),5), cells(i_btm(i1),6), cells(i_btm(i1),7)-cells(i_btm(i1),4), cells(i_btm(i1),8)-cells(i_btm(i1),5), cells(i_btm(i1),9)-cells(i_btm(i1),6), 'b', 'ShowArrowHead','off', 'Autoscale','off');
hold on;
quiver3(cells(i_btm(i2),4), cells(i_btm(i2),5), cells(i_btm(i2),6), cells(i_btm(i2),7)-cells(i_btm(i2),4), cells(i_btm(i2),8)-cells(i_btm(i2),5), cells(i_btm(i2),9)-cells(i_btm(i2),6), 'r', 'ShowArrowHead','off', 'Autoscale','off');
```
You can adjust the view angles of the plot by:
`view(0,90);`

***

## where is the information about cell division, cell age stored?
Cell ages and division time of the two ends are stored in columns 24-27 of the output files under `Cells` folder. You may refer to the last a few lines of `InputOutput.cpp` for more details.

***

## Setting the level of grids and choose the Box_x, Box_y, Box_z, and Box_z_agar
There is a parameter maxLevels in `in1.txt` file that specifies the level of grids. I usually choose `maxLevels` to be 2~4. Usually we want `Box_x=Box_y` with `mod(Box_x,4)=0`, and `mod(Box_z_agar,4)=0`

***

## Reading the AgarField and WallField data
(Let's assume that we have Box_x=Box_y=128 and Box_z_agar=20)
Read the AgarField data:
```Matlab
agar=load(sprintf('%s/AgarField/%d.txt',dir_cells,i_cells));
```
break the data into trunks (corresponds to different levels of the grid):
```Matlab
agar0=agar(1:end/4,:);
agar1=agar(1+end/4:end/2,:);
agar2=agar(1+end/2:end*3/4,:);
agar3=agar(1+end*3/4:end,:);
```
reshape the matrices:
```Matlab
agar0=reshape(agar0, Box_y, 2*Box_z_agar, Box_x);
agar1=reshape(agar1, Box_y, 2*Box_z_agar, Box_x);
agar2=reshape(agar2, Box_y, 2*Box_z_agar, Box_x);
agar3=reshape(agar3, Box_y, 2*Box_z_agar, Box_x);
```
Define the carbon fields:
```Matlab
carb0=agar0(:,1:end/2,:);
carb1=agar1(:,1:end/2,:);
carb2=agar2(:,1:end/2,:);
carb3=agar3(:,1:end/2,:);
```

Then we fill in the part of higher level grid that should be covered by the lower level grid:
```Matlab
carb1(Box_y/4+1:Box_y*3/4, 1:Box_z_agar/2, Box_x/4+1:Box_x*3/4)=carb0(1:2:Box_y, 2:2:Box_z_agar, 1:2:Box_x);
carb2(Box_y/4+1:Box_y*3/4, 1:Box_z_agar/2, Box_x/4+1:Box_x*3/4)=carb1(1:2:Box_y, 2:2:Box_z_agar, 1:2:Box_x);
carb3(Box_y/4+1:Box_y*3/4, 1:Box_z_agar/2, Box_x/4+1:Box_x*3/4)=carb2(1:2:Box_y, 2:2:Box_z_agar, 1:2:Box_x);
```
Then you can visualize the carbon field data in different levels, for example:
```Matlab
imagesc(reshape(carb1(:,1,:), Box_y, Box_x));
imagesc(reshape(carb2(Box_y/2,:,:), Box_z_agar, Box_x));
```
