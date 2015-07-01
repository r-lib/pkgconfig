
# Persistent configuration for R packages

[![Linux Build Status](https://travis-ci.org/gaborcsardi/pkgconfig.svg?branch=master)](https://travis-ci.org/gaborcsardi/pkgconfig)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/gaborcsardi/pkgconfig?svg=true)](https://ci.appveyor.com/project/gaborcsardi/pkgconfig)
[![](http://www.r-pkg.org/badges/version/pkgconfig)](http://cran.rstudio.com/web/packages/pkgconfig/index.html)


Easy way to create configuration parameters in your R package. Configuration
values of the same key are independent for different packages.


## Installation

Use the `devtools` package:

```r
devtools::install_github("gaborcsardi/pkgconfig")
```

## Usage

Call `get_config()` to query the value of a configuration parameter,
`set_config()` to set them.

Create an object called `_pkgconfig_defaults` for the default values
of you configuration parameters.

## Feedback

Please comment in the
[Github issue tracker](https://github.com/gaborcsardi/pkgconfig/issues)
of the project.
