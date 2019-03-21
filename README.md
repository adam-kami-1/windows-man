

windows-man
#################################################################################


Man pages for Windows commands

At the moment there are not available any man pages for windows applications.
But you can find here the batch file man.bat which can be used to display man
pages available e.g. in packages MinGW or GnuWin32.


To use man.bat you should configure environment variable MANPATH to semicolon
separated list of paths containing man files.

Possible locations of man pages in Windows system:
...\GnuWin32\man
...\emacs-24.5\share\man
...\MinGW\msys\1.0\share\man
...\MinGW\share\man

man.bat requires following applications:

gzip             available in GnuWin32 or MinGW
groff            available in GnuWin32
sed              available in GnuWin32 or MinGW
less             available in GnuWin32 or MinGW

Currently it requires also windows application reg, but this will change soon.
