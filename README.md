gmp4osx
=============

This is the GNU [GMP](http://gmplib.org/) Math Library for osx compiled with xcode 3.2.3.
The main objective of this development should be to create an osx framework
that is usable for osx and iphone development.

How to build
-----------
1. open gmpbuild.xcodeproj and build target gen-src
   * symbolic links in the build directory for the three 
     supported platforms x86_64 (macos), i386(iPhoneSimulator) and armv6/7(iPhoneOS)
     are created
   * the code generation programs gen-fac_ui, gen-fib,gen-bases,gen-psqr are created
   * this programs as called to generate code and header files in the
     build/src,build/src32,build/include and build/include32 directories
2. open gmplib.xcodeproj to create a 64bit gmp framework for MacOS
   * build the gmp target to produce a 64bit framework for MacOS
   * build the gmp-unittest target to build and call the unit tests
   * build the gmp-calc target to build and call the command line test tool using
     gmp framework
   
T.B.D.

Usage
-----

T.B.D.

Testing
-------

T.B.D.


[r2h]: http://github.com/github/markup/tree/master/lib/github/commands/rest2html
[r2hc]: http://github.com/github/markup/tree/master/lib/github/markups.rb#L13
[1]: http://github.com/github/markup/issues

