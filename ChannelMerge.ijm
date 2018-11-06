print("\\Clear")

//	MIT License

//	Copyright (c) 2018 Nicholas Condon n.condon@uq.edu.au

//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:

//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.

//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.



scripttitle="IMB_ChannelMerge";
version="0.5";
versiondate="13/08/2018";
description="Details: <br> This script takes single images from a folder and merges them into user defined channels. <br><br> Folders should contain only images in the correct order (ie. Red, Green, Blue, Red, Green, Blue...) <br><br> Directory structure should include a folder for Raw Images and one for merged images (not within the Raw Image Folder)."
    
    showMessage("Institute for Molecular Biosciences ImageJ Script", "<html>" 
    +"<h1><font size=6 color=Teal>ACRF: Cancer Biology Imaging Facility</h1>
    +"<h1><font size=5 color=Purple><i>The Institute for Molecular Bioscience <br> The University of Queensland</i></h1>
    +"<h4><a href=http://imb.uq.edu.au/Microscopy/>ACRF: Cancer Biology Imaging Facility</a><\h4>"
    +"<h1><font color=black>ImageJ Script Macro: "+scripttitle+"</h1> "
    +"<p1>Version: "+version+" ("+versiondate+")</p1>"
    +"<H2><font size=3>Created by Nicholas Condon</H2>"	
    +"<p1><font size=2> contact n.condon@uq.edu.au \n </p1>" 
    +"<P4><font size=2> Available for use/modification/sharing under the "+"<p4><a href=https://opensource.org/licenses/MIT/>MIT License</a><\h4> </P4>"
    +"<h3>   <\h3>"    
    +"<p1><font size=3 \b i>"+description+".</p1>"
   	+"<h1><font size=2> </h1>"  
	+"<h0><font size=5> </h0>"
    +"");

//Log Window Title and Acknowledgement
print("");
print("FIJI Macro: "+scripttitle);
print("Version: "+version+" ("+versiondate+")");
print("ACRF: Cancer Biology Imaging Facility");
print("By Nicholas Condon (2018) n.condon@uq.edu.au")
print("");
getDateAndTime(year, month, week, day, hour, min, sec, msec);
print("Script Run Date: "+day+"/"+(month+1)+"/"+year+"  Time: " +hour+":"+min+":"+sec);
print("");
     
//Selecting the number of channels for final output images 
 Dialog.create("Number of Channels");
 Dialog.addMessage("Select the number of channels for your merged images");
 Dialog.addMessage(" ");
 // Dialog.addChoice("Number of channels:", newArray("2", "3", "4"));    <------ //Blanked out as 4-channel not currently working
 Dialog.addChoice("Number of channels:", newArray("2", "3"));Dialog.show();
numChen = Dialog.getChoice();

print("**** Parameters ****");
print("Number of channels to merge: "+numChen);


//Selecting the LUTs for each channel
//For 2 channel images
if (numChen=="2") {
	Dialog.create("Select LUT for Channels");
	Dialog.addMessage("Select the LUTs for your two channels")
    Dialog.addMessage(" ")
	Dialog.addChoice("Channel1:", newArray("Red", "Green", "Blue", "Grays", "Cyan", "Magenta", "Yellow"));
	Dialog.addChoice("Channel2:", newArray("Green", "Red", "Green", "Grays", "Cyan", "Magenta", "Yellow"));
	Dialog.show();
		Channel1 = Dialog.getChoice();
		Channel2 = Dialog.getChoice();
		print("Channel 1 LUT = "+Channel1);
		print("Channel 2 LUT = "+Channel2);
		}

//For 3 channel images
	else if (numChen=="3") {
		Dialog.create("Select LUT for Channels");
		Dialog.addMessage("Select the LUTs for your three channels")
    	Dialog.addMessage(" ")
		Dialog.addChoice("Channel1:", newArray("Red", "Green", "Blue", "Grays", "Cyan", "Magenta", "Yellow"));
		Dialog.addChoice("Channel2:", newArray("Green", "Red", "Green", "Grays", "Cyan", "Magenta", "Yellow"));
		Dialog.addChoice("Channel3:", newArray("Blue", "Red", "Green", "Grays", "Cyan", "Magenta", "Yellow"));
		Dialog.show();
			Channel1 = Dialog.getChoice();
			Channel2 = Dialog.getChoice();;
			Channel3 = Dialog.getChoice();;
			print("Channel 1 LUT = "+Channel1);
			print("Channel 2 LUT = "+Channel2);
			print("Channel 3 LUT = "+Channel3);
			}

//For 4 channel images (Disabled due to ImageJ2 limitations)
	else if (numChen=="4") {
		Dialog.create("Select LUT for Channels");
		Dialog.addMessage("Select the LUTs for your four channels")
    	Dialog.addMessage(" ")
		Dialog.addChoice("Channel1:", newArray("Red", "Green", "Blue", "Grays", "Cyan", "Magenta", "Yellow"));
		Dialog.addChoice("Channel2:", newArray("Green", "Red", "Blue", "Grays", "Cyan", "Magenta", "Yellow"));
		Dialog.addChoice("Channel3:", newArray("Blue", "Red", "Green", "Grays", "Cyan", "Magenta", "Yellow"));
		Dialog.addChoice("Channel4:", newArray("Grays", "Red", "Green", "Blue", "Cyan", "Magenta", "Yellow"));
		Dialog.show();
			Channel1 = Dialog.getChoice();
			Channel2 = Dialog.getChoice();
			Channel3 = Dialog.getChoice();
			Channel4 = Dialog.getChoice();
			print("Channel 1 LUT = "+Channel1);
			print("Channel 2 LUT = "+Channel2);
			print("Channel 3 LUT = "+Channel3);
			print("Channel 4 LUT = "+Channel4);
		}

print("");

//Prompt for user about directory structure
title = "Folder Selection Selections";
msg = "First Select Input Directory, then Output Directory (must be two different folders)";
waitForUser(title, msg);

//Directory selection
dir1 = getDirectory("Choose Source Directory ");
      dir2 = getDirectory("Choose Destination Directory ");
      list = getFileList(dir1);
      setBatchMode(true);
      n = list.length;


//Timer Sequence start
start = getTime();


    

//2-channel merging section   
      if ((n%numChen)!=0)
         exit("The number of files must be a multiple of "+numChen);
      stack = 0;
      first = 0;  
      if (numChen==2) {
       for (i=0; i<n/numChen; i++) {
          channel1 = list[numChen*i];
          channel2 = list[numChen*i+1];
          
          
	  	print("Merging:" +channel1+"  "+channel2+"\n");
          open(dir1 +channel1);
          	run(Channel1);
          open(dir1 +channel2);
          	run(Channel2);
          	run("Merge Channels...", "c1=["+channel1+"] c2=["+channel2+"] create");
          	saveAs("tiff", dir2+channel1+"merged");
          	close();
	       }}

//3-channel merging section       
       else if ((n%numChen)!=0)
         exit("The number of files must be a multiple of "+numChen);
      stack = 0;
      first = 0;
      if (numChen==3) {
       for (i=0; i<n/numChen; i++) {
          channel1 = list[numChen*i];
          channel2 = list[numChen*i+1];
          channel3 = list[numChen*i+2];
          
	  	print("Merging:" +channel1+"  "+channel2+" "+channel3+"\n");
          open(dir1 +channel1);
          	run(Channel1);
          open(dir1 +channel2);
          	run(Channel2);
          open(dir1 +channel3);
          	run(Channel3);
 	      	run("Merge Channels...", "c1=["+channel1+"] c2=["+channel2+"] c3=["+channel3+"] create");
          	saveAs("tiff", dir2+channel1+"merged");
          	close();
	       }}

//4-channel merging section (Disabled)       
       else if ((n%numChen)!=0)
         exit("The number of files must be a multiple of "+numChen);
      stack = 0;
      first = 0;
      if (numChen==4) {
       for (i=0; i<n/numChen; i++) {
          channel1 = list[numChen*i];
          channel2 = list[numChen*i+1];
          channel3 = list[numChen*i+2];
          channel4 = list[numChen*i+3];
	  	print("Merging:" +channel1+"  "+channel2+" "+channel3+" "+channel4+"\n");
          open(dir1 +channel1);
          	run(Channel1);
          	//type = "RGB";
          open(dir1 +channel2);
          	run(Channel2);
          	//type = "RGB";
          open(dir1 +channel3);
          	run(Channel3);
          	//type = "RGB";
          open(dir1 +channel4);
          	run(Channel4);
            //type = "RGB";
          	run("Merge Channels...", "c1=["+channel1+"] c2=["+channel2+"] c3=["+channel3+"] ch4=["+channel4+"] create");
          	//selectWindow("Composite");
          	saveAs("tiff", dir2+channel1+"merged");
          	close();
          	 }}

//Batch Finalisation


//exiting loop
print("");
print("Batch Completed");
print("Total Runtime was:");
print((getTime()-start)/1000); 

//saving log file loop
selectWindow("Log");
saveAs("Text", dir2+"Log_ChannelMerge.txt");
title = "Batch Completed";
msg = "Images are all merged.";
msg= "Files can be found:["+dir2+"]";
waitForUser(title, msg);
