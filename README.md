


windows-man
================================================================================



Man pages for Windows commands
--------------------------------------------------------------------------------

At the moment there are not available any man pages for windows applications.

But you can find here the batch file man.bat which can be used to display man
pages available e.g. in packages MinGW or GnuWin32.

There is also available bash script man to be used under bash delivered e.g. by
MinGW SYS bash or Git bash.

Batch file man.bat to be used in Command Prompt and PowerShell
--------------------------------------------------------------------------------

Supported syntax for man.bat is:

man [-d] [section] page

man [-d] page[.section]

man [--debug] [section] page

man [--debug] page[.section]

To use man.bat you should configure environment variable MANPATH to semicolon
separated list of paths containing man files. IF MANPATH is not defined the PATH
is analyzed to find man pages delivered with following packages: MinGW, GnuWin32,
and emacs.

Possible locations of man pages in Windows system:
...\GnuWin32\man
...\emacs-24.5\share\man
...\MinGW\msys\1.0\share\man
...\MinGW\share\man

man.bat requires following applications:

| Application | Available in      |
|:------------|:------------------|
| gzip        | GnuWin32 or MinGW |
| groff       | GnuWin32          |
| sed         | GnuWin32 or MinGW |
| less        | GnuWin32 or MinGW |

In my environment GnuWin32 version of less does not understand VT100 control
sequences so I need to force MinGW to be earlier in PATH, befor GnuWin32.

MinGW implementation of less inerprets underline mode as a blue foreground.

To use this script in PowerShel you need to use full name man.bat because man
is an alias for function help().

Script man to be used under bash
--------------------------------------------------------------------------------

