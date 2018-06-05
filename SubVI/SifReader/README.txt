Getting Started with the LabVIEW SIF reader:

There are 2 folders contained within this folder.  The version required depends on what version of LabVIEW being used; 

32-bit LabView:
Copy the contents (maintaining folder structure) of win32 to the labVIEW root folder (contains LabVIEW.exe)
to test if successful look for ATSIFIO.dll and ATSpooler.dll in the LabVIEW root folder.

64-bit LabView:
Copy the contents (maintaining folder structure) of x64 to the labVIEW root folder (contains LabVIEW.exe)
to test if successful look for ATSIFIO64.dll and ATSpooler.dll in the LabVIEW root folder.

When LabVIEW is restarted the ATSIFIO library functions should be available through the User Libraries palette.


Folder contents:

win32/
--> ATSIFIO.dll (32 bit version of the runtime library required to open SIF files)
-->ATSPOOLER.dll (32 bit version of a runtime file (required for opening sifx files) that ATSIFIO.dll requires)
--> ImageLoader.vi (example demonstrating the use of the SISIO library)
--> user.lib 
    --> ATSIFIO.llb (the LabVIEW instrument library for SIF)


x64/
--> ATSIFIO64.dll (64 bit version of the runtime library required to open SIF files)
-->ATSPOOLER.dll (64 bit version of a runtime file (required for opening sifx files) that ATSIFIO.dll requires)
--> ImageLoader.vi (example demonstrating the use of the SISIO library)
--> user.lib 
    --> ATSIFIO64.llb (the LabVIEW instrument library for SIF)