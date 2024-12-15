redbash is userland macports with the target of RHEL.

redbash is an attempt to install [macports](https://www.macports.org/), which is for macos but can be installed with root on [Ubuntu] (https://trac.macports.org/wiki/InstallingMacPortsOnUbuntuLinux), as a userland package on RHEL where one does not have root access.  This is achieved by building all of the support utilites that are required to compile macports, which are all inherently BSD.

Firstly, BSD has a different sed, and for that reason I've done a port of BSD's sed as [bsdsed](https://github.com/bpdegnan/bsdsed). 

Secondly, paths are challenging, and for this reason there's a structure of:
    
    ./
    ./private/bin
    ./private/opt
      
The private directory has untilties that are required to build macports, and macports is installed into opt.

In order to get the package, I generally run: 

	wget https://github.com/bpdegnan/redbash/archive/refs/heads/main.zip -O redbash-main.zip



In order to install the packages, clone this repository and then run ./setuppaths.sh.  You will need logout and back in to update the paths, or rerun your shell.  Next run installmacports.sh to try to build things.  You can then do a "port selfupdate"  You need to sort out the bsdsed to run as sed because I've been unable to pull that off without root access still; however, you can do the following to prove things are working:

    port -v install libffi
