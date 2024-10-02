redbash is an attempt to install [macports](https://www.macports.org/), which is for macos but can be installed with root on [Ubuntu] (https://trac.macports.org/wiki/InstallingMacPortsOnUbuntuLinux), as a userland package on RHEL where one does not have root access.  

Firstly, bsd has a different sed, and for that reason I've done a port of BSD's sed as [bsdsed](https://github.com/bpdegnan/bsdsed). 

Secondly, paths are challenging, and for this reason there's a structure of:
    
    ./
    ./private/bin
    ./private/opt
      
The private directory has untilties that are required to build macports, and macports is installed into opt.

In order to install the packages, clone this repository and then run ./setuppaths.sh followed by installmacports.sh.  You can then do a "port selfupdate"  You need to sort out the bsdsed to run as sed because I've been unable to pull that off without root access still; however, you can do the following to prove things are working:

    port -v install libffi
