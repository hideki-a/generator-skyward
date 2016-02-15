/*!
 *
 *  Web Starter Kit
 *  Copyright 2015 Google Inc. All rights reserved.
 *  Copyright 2016 Hideki Abe All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License
 *
 */

'use strict';

require('babel-register');
import gulp from 'gulp';
import del from 'del';
import runSequence from 'run-sequence';
import browserSync from 'browser-sync';
import browserSyncSSI from 'browsersync-ssi';
import gulpLoadPlugins from 'gulp-load-plugins';
import autoprefixer from 'autoprefixer';
import mqpacker from 'css-mqpacker';
import perfectionist from 'perfectionist';

const $ = gulpLoadPlugins();
const reload = browserSync.reload;

// Compile and automatically prefix stylesheets
gulp.task('styles', () => {
  const AUTOPREFIXER_BROWSERS = [
    'last 2 versions',
    'ie >= 9',
  ];
  const PROCESSORS = [
    autoprefixer({ browsers: AUTOPREFIXER_BROWSERS }),
    mqpacker(),
    perfectionist()
  ];

  // For best performance, don't add Sass partials to `gulp.src`
  return gulp.src([
    '../htdocs/_scss/*.scss'
  ])
    .pipe($.newer('.tmp/common/css'))
    .pipe($.sourcemaps.init())
    .pipe($.sass({
      precision: 3,
      includePaths: require('node-neat').includePaths
    }).on('error', $.notify.onError((error) => {
      return error.message;
    })))
    .pipe($.postcss(PROCESSORS))
    .pipe(gulp.dest('.tmp/common/css'))
    .pipe($.size({ title: 'styles' }))
    .pipe($.sourcemaps.write('./'))
    .pipe(gulp.dest('../htdocs/common/css'));
});

// Optimize images
gulp.task('images', () =>
  gulp.src('../dist/**/*.{png,jpe?g,gif,svg}')
    .pipe($.cache($.imagemin({
      progressive: true,
      interlaced: true
    })))
    .pipe(gulp.dest('../dist'))
);

// Lint JavaScript
gulp.task('eslint', () =>
  gulp.src([
    '../htdocs/**/*.js',
    '!../htdocs/**/components/*.js'
  ])
    .pipe($.eslint('.eslintrc'))
    .pipe($.eslint.format())
    .pipe($.eslint.failOnError())
    .on('error', $.notify.onError((error) => {
      return error.message;
    }))
);

// Make sitemap.xml
gulp.task('sitemap', () =>
  gulp.src('../dist/**/*.html')
    .pipe($.sitemap({ siteUrl: 'http://192.168.24.7:3501'}))
    .pipe(gulp.dest('../dist'))
);

// Clean output directory
gulp.task('clean:tmp', () => del(['.tmp'], { dot: true }));
gulp.task('clean:dist', () => del(['../dist'], { dot: true, force: true }));

// Copy all files at the root level (app)
gulp.task('copy', () =>
  gulp.src([
    '../htdocs/**/*'
  ], {
    dot: true
  }).pipe(gulp.dest('../dist'))
    .pipe($.size({ title: 'copy' }))
);

// Serve
// ghostMode: Clicks, Scrolls & Form inputs on any device will be mirrored to all others.
gulp.task('serve', () => {
  browserSync({
    server: '../htdocs/',
    port: 3501,
    ghostMode: false,
    browser: 'google chrome',
    startPath: '/',
    middleware: browserSyncSSI({
      baseDir: __dirname + '/../htdocs',
      ext: '.html'
    })
  });

  gulp.watch(['../htdocs/**/*.html'], reload);
  gulp.watch(['../htdocs/_scss/*.scss'], ['styles', reload]);
  gulp.watch(['../htdocs/**/*.js'], ['eslint', reload]);
});

gulp.task('serve:dist', () => {
  browserSync({
    server: '../dist/',
    port: 3501
  });
});

// Default task
gulp.task('default', ['clean:tmp'], cb =>
  runSequence(
    'styles',
    'serve',
    cb
  )
);

// Publish production files
gulp.task('publish', ['clean:dist'], cb =>
  runSequence(
    'styles',
    'copy',
    'images',
    cb
  )
);
