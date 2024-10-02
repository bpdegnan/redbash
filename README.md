redbash is an attempt to install [macports](https://www.macports.org/), which is for macos but can be installed with root on [Ubuntu] (https://trac.macports.org/wiki/InstallingMacPortsOnUbuntuLinux), as a userland package on RHEL where one does not have root access.  

Firstly, bsd has a different sed, and for that reason I've done a port of BSD's sed as [bsdsed](https://github.com/bpdegnan/bsdsed). 
Secondly, paths are challenging, and for this reason there's a structure of:

   ./
   ./private/bin
   ./private/opt
   
The private directory has untilties that are required to build macports, and macports is installed into opt.


