# gibasa 1.1.0

## Test environments

- R-hub ubuntu-gcc-release (r-release)
- R-hub debian-clang-devel (r-devel)
- R-hub windows-x86_64-oldrel (r-oldrel)
- R-hub windows-x86_64-devel (r-devel)

## R CMD check results

* On ubuntu-gcc-release (r-release)
  checking installed package size ... NOTE
    installed size is 18.9Mb
    sub-directories of 1Mb or more:
      libs  18.5Mb

* On ubuntu-gcc-release (r-release), debian-clang-devel (r-devel), windows-x86_64-oldrel (r-oldrel), windows-x86_64-devel (r-devel)
  checking for GNU extensions in Makefiles ... NOTE
  GNU make is a SystemRequirements.

* On ubuntu-gcc-release (r-release)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

* On windows-x86_64-oldrel (r-oldrel), windows-x86_64-devel (r-devel)
  checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''

* On windows-x86_64-oldrel (r-oldrel), windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors | 0 warnings | 5 notes

## revdepcheck

There are currently no downstream dependencies for this package.
