* This is a resubmisson.
* In response to comments from CRAN, I made following changes.
  * Rewrote the description text.
  * Added 'Jorge Nocedal' to the 'Authors@R' field as a contributor.

---

## Test environments
- R-hub macos-highsierra-release-cran (r-release)
- R-hub ubuntu-gcc-devel (r-devel)
- R-hub debian-gcc-release (r-release)

## R CMD check results
❯ On ubuntu-gcc-devel (r-devel)
  checking CRAN incoming feasibility ... [9s/48s] NOTE
  Maintainer: ‘Akiru Kato <paithiov909@gmail.com>’
  
  New submission

❯ On ubuntu-gcc-devel (r-devel), debian-gcc-release (r-release)
  checking for GNU extensions in Makefiles ... NOTE
  GNU make is a SystemRequirements.

❯ On ubuntu-gcc-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

❯ On debian-gcc-release (r-release)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: ‘Akiru Kato <paithiov909@gmail.com>’
  
  New submission

❯ On debian-gcc-release (r-release)
  checking installed package size ... NOTE
    installed size is 12.2Mb
    sub-directories of 1Mb or more:
      libs  11.9Mb

0 errors ✔ | 0 warnings ✔ | 5 notes ✖
