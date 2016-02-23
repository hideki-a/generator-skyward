generator-skyward [![Build Status](https://secure.travis-ci.org/hideki-a/generator-skyward.png?branch=master)](http://travis-ci.org/hideki-a/generator-skyward)
=================

Yeoman generator for scaffolding out a website.

## Features

* Built-in preview server
* Automagically compile Sass(with Libsass)
* Lint your scripts
* Automagically wire up your Bower components.
* Awesome Image Optimization
* Generate Styleguide

For more information on what `generator-skyward` can do for you, take a look at the [Grunt tasks](https://github.com/hideki-a/generator-skyward/blob/master/app/templates/Gruntfile.coffee) used in our `Gruntfile.coffee`.

## Getting Started

- Install: `npm install -g generator-skyward`
- Run: `yo skyward`
- `cd tools`
- Run: `npm start`(or `gulp`) for building

## Options

* `--skip-install`

  Skips the automatic execution of `bower` and `npm` after scaffolding has finished.

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)
