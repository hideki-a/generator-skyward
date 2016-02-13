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
        # proxy: 'generator-skyward.localhost'
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
      hologram_pc:
        cmd: '(cd hologramStuff; bundle exec hologram config.yml; cd ../)'
      hologram_sp:
        cmd: '(cd hologramStuff; bundle exec hologram config_sp.yml; cd ../)'

    # newer:
    #   options:
    #     override: checkForModifiedImports

    # Settings for Hologram
    replace:
      styleguide_css_pc:
        src: ['../docs/styleguide_pc/common/css/*.css']
        dest: '../docs/styleguide_pc/common/css/'
        replacements: [
          {
            from: /\/english\/common\/(images|fonts)/g
            to: '../$1'
          },
          {
            from: /\(\/english\/(images|_dev)/g
            to: '(../../$1'
          },
          {
            from: /body(\s*?){/g
            to: ':host$1{'
          },
        ]
      styleguide_html_pc:
        src: ['../docs/styleguide_pc/*.html']
        dest: '../docs/styleguide_pc/'
        replacements: [
          {
            from: '/english/common/images'
            to: 'common/images'
          },
          {
            from: /"\/english\/(images|_dev)/g
            to: '"$1'
          },
        ]
      styleguide_css_sp:
        src: ['../docs/styleguide_sp/common/css/*.css']
        dest: '../docs/styleguide_sp/common/css/'
        replacements: [
          {
            from: /\/english\/sp\/common\/(images|fonts)/g
            to: '../$1'
          },
          {
            from: /\(\/english\/sp\/(images|_dev)/g
            to: '(../../$1'
          },
          {
            from: /body(\s*?){/g
            to: ':host$1{'
          },
        ]
      styleguide_html_sp:
        src: ['../docs/styleguide_sp/*.html']
        dest: '../docs/styleguide_sp/'
        replacements: [
          {
            from: '/english/sp/common/images'
            to: 'common/images'
          },
          {
            from: /"\/english\/sp\/(images|_dev)/g
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

  grunt.registerTask 'styleguide_pc', [
    # 'sass:dist'
    # 'autoprefixer:dist'
    'exec:hologram_pc'
    'replace:styleguide_css_pc'
    'replace:styleguide_html_pc'
  ]

  grunt.registerTask 'styleguide_sp', [
    # 'sass:dist'
    # 'autoprefixer:dist'
    'exec:hologram_sp'
    'replace:styleguide_css_sp'
    'replace:styleguide_html_sp'
  ]
  return;
