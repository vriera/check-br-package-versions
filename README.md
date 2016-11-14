This software aims to help Buildroot developers to check for new versions of packages.

The script makes use of two environmental variables, `BR_REPO` and `BR_BRANCH`. The first one is mandatory but the second one is optional, and it will default to `master` if not specified.
It accepts a space separated list of packages as arguments. If no packages are specified it will check for all of them.

Example of usage:

```
$ export BR_REPO=/home/user/buildroot
$ export BR_BRANCH=next
$ ./check-br-package-versions.sh flex xz-utils
```
