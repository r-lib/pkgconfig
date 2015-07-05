
# Private configuration for R packages

[![Linux Build Status](https://travis-ci.org/gaborcsardi/pkgconfig.svg?branch=master)](https://travis-ci.org/gaborcsardi/pkgconfig)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/gaborcsardi/pkgconfig?svg=true)](https://ci.appveyor.com/project/gaborcsardi/pkgconfig)
[![](http://www.r-pkg.org/badges/version/pkgconfig)](http://cran.rstudio.com/web/packages/pkgconfig/index.html)

Easy way to create configuration parameters in your R package. Configuration
values set in different packages, are independent.

## Installation

Use the `devtools` package:

```r
devtools::install_github("gaborcsardi/pkgconfig")
```

## Usage

Call `set_config()` to set a configuration parameter.
Call `get_config()` to query it.

## Feedback

Please comment in the
[Github issue tracker](https://github.com/gaborcsardi/pkgconfig/issues)
of the project.
