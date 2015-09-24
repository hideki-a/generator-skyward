'use strict'
checkForModifiedImports = require('./lib/grunt-newer-util').checkForModifiedImports
ssi = require 'browsersync-ssi'

module.exports = (grunt) ->
  require('jit-grunt') grunt,
    replace: 'grunt-text-replace'
    htmllint: 'grunt-html'
  grunt.loadNpmTasks 'grunt-notify'
  ip = require('ip')

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    sass:
      options:
        precision: 3
        includePaths: require('node-neat').includePaths
      dev:
       files: [
          expand: true
          cwd: '../htdocs/_scss'
          src: ['*.scss']
          dest: '../htdocs/common/css'
          ext: '.css'
        ]
        options:
          outputStyle: 'expanded'
          sourceMap: true
      dist:
        files: [
          expand: true
          cwd: '../htdocs/_scss'
          src: ['*.scss']
          dest: '../release/common/css'
          ext: '.css'
        ]
        options:
          outputStyle: 'expanded'
          sourceMap: false

    browserSync:
      options:
        # host: '192.168.24.15'
        port: 3501
        server:
          baseDir: '../htdocs'
          middleware: ssi(
              baseDir: __dirname + '/../htdocs'
              ext: '.html'
            )
        # proxy: '<%= pkg.name %>.localhost'
      dev:
        bsFiles:
          src: [
            '../htdocs/**/*.html'
            '../htdocs/**/*.css'
            '../htdocs/**/*.js'
          ]
        options:
          watchTask: true
          browser: 'Google Chrome'
          # startPath: '/_dev/'
      serve:
        options:
          watchTask: false
    
    watch:
      sass:
        files: '../htdocs/**/*.scss'
        tasks: [
          'sass:dev'
          'autoprefixer:dev'
          # 'newer:sass:dev'
          # 'newer:autoprefixer:dev'
        ]

      gruntfile:
        files: 'Gruntfile.coffee'

    autoprefixer:
      options:
        browser: [
          'last 2 version'
          'Firefox ESR'
          'ie 9'
          'ie 8'
        ]
      dev:
        src: '../htdocs/common/css/*.css'
        options:
          map: true
      dist:
        src: '../release/common/css/*.css'
        options:
          map: false

    image:
      all:
        files: [
          expand: true
          cwd: '../htdocs'
          src: ['**/*.{png,jpg,svg}']
          dest: '../release'
        ]

    jshint:
      options:
        jshintrc: '.jshintrc'
      all: [
        '../htdocs/**/*.js'
        '!../htdocs/common/js/components/*.js'
      ]

    uglify:
      options:
        preserveComments: 'some'
      dist:
        files:
          'path/to/dest.js': ['path/to/src.js']

    concat:
      compo:
        src: ['../htdocs/common/js/components/*.js']
        dest: '../htdocs/common/js/components.js'

    csslint:
      dist:
        src: [
          '../htdocs/**/*.css'
          '!../htdocs/common/css/extras/*.css'
        ]
        options:
          csslintrc: '.csslintrc'

    csscomb:
      dynamic_map:
        expand: true
        cwd: '../release/common/css/'
        src: '*.css'
        dest: '../release/common/css/'

    combine_mq:
      default_options:
        expand: true
        cwd: '../release/common/css/'
        src: '*.css'
        dest: '../release/common/css/'

    cssmin:
      dist:
        files: [
          expand: true
          src: [
            '../release/**/*.css'
            '!../release/**/*.min.css'
          ]
          ext: '.css'
        ]

    htmllint:
      all: [
        '../htdocs/**/*.html'
        '!../htdocs/_scss/**/*.html'
      ]

    clean:
      release:
        src: ['../release/']
        options:
          force: true

    copy:
      release:
        files: [
          expand: true
          cwd: '../htdocs/'
          src: ['**']
          dest: '../release/'
        ]

    exec:
      hologram:
        cmd: '(cd hologramStuff; bundle exec hologram config.yml; cd ../)'

    # newer:
    #   options:
    #     override: checkForModifiedImports

    # Settings for Hologram
    replace:
      styleguide_css:
        src: ['../docs/styleguide/common/css/*.css']
        dest: '../docs/styleguide/common/css/'
        replacements: [
          {
            from: /\/common\/(images|fonts)/g
            to: '../$1'
          },
          {
            from: /\(\/(images|_dev)/g
            to: '(../../$1'
          },
        ]
      styleguide_html:
        src: ['../docs/styleguide/*.html']
        dest: '../docs/styleguide/'
        replacements: [
          {
            from: '/common/images'
            to: 'common/images'
          },
          {
            from: /"\/(images|_dev)/g
            to: '"$1'
          },
        ]

  # Register tasks.
  grunt.registerTask 'default', [
    'sass:dev'
    'autoprefixer:dev'
    'browserSync:dev'
    'watch'
  ]

  grunt.registerTask 'publish', [
    'clean:release'
    'copy:release'
    # 'jshint'
    # 'concat'
    # 'uglify'
    'sass:dist'
    'autoprefixer:dist'
    'csscomb'
    'combine_mq'
    'cssmin'
    'image:all'
  ]

  grunt.registerTask 'serve', [
    'browserSync:serve'
  ]

  grunt.registerTask 'styleguide', [
    'sass:dist'
    'autoprefixer:dist'
    'exec:hologram'
    'replace'
  ]

  return;
