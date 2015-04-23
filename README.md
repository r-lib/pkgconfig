
# Persistent configuration for R packages

[![Linux Build Status](https://travis-ci.org/gaborcsardi/pkgconfig.svg?branch=master)](https://travis-ci.org/gaborcsardi/pkgconfig)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/gaborcsardi/pkgconfig?svg=true)](https://ci.appveyor.com/project/gaborcsardi/pkgconfig)


Easy way to create configuration parameters in your R package. The user can
then configure your package via site, user or project level configuration
files.

## Installation

Use the `devtools` package:

```r
devtools::install_github("gaborcsardi/pkgconfig")
```

## Usage

Call `get_config()` to query the value of a configuration parameter.
`set_config()` sets configuration parameters, and potentially writes
them to files.

Create an object called `_pkgconfig_defaults` for the default values
of you configuration parameters.

## Feedback

Please comment in the
[Github issue tracker](https://github.com/gaborcsardi/pkgconfig/issues)
of the project.
