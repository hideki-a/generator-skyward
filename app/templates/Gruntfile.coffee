'use strict'
LIVERELOAD_PORT = 35729
lrSnippet = require('connect-livereload')({ port: LIVERELOAD_PORT })
proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest
checkForModifiedImports = require('./lib/grunt-newer-util').checkForModifiedImports
mountFolder = (connect, dir) ->
  return connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
  require('jit-grunt') grunt,
    xmlsitemap: 'grunt-simple-xmlsitemap'
  grunt.loadNpmTasks 'grunt-connect-proxy'    # https://github.com/drewzboto/grunt-connect-proxy/issues/56
  grunt.loadNpmTasks 'grunt-notify'
  ip = require('ip')

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    sass:
      options:
        # compass: true
        precision: 3

      dev:
        # files:
        #   '../htdocs/common/css/basic.css': '../htdocs/_scss/basic.scss'
        files: [
          expand: true
          cwd: '../htdocs/_scss'
          src: ['*.scss']
          dest: '../htdocs/common/css'
          ext: '.css'
        ]
        options:
          style: 'expanded'
      dist:
        files: [
          expand: true
          cwd: '../htdocs/_scss'
          src: ['*.scss']
          dest: '../htdocs/common/css'
          ext: '.css'
        ]
        options:
          style: 'expanded'
          sourcemap: 'none'

    connect:
      livereload:
        options:
          hostname: '0.0.0.0'
          port: 3501
          middleware: (connect, options) ->
            return [
              lrSnippet
              proxySnippet
              mountFolder(connect, '../htdocs')
            ]
          open:
            target: 'http://localhost:<%= connect.livereload.options.port %>'
            appName: 'Google Chrome'
      proxies: [
        context: '/contact'
        host: '<%= pkg.name %>.localhost'
        headers:
          'Host': '<%= pkg.name %>.localhost'
      ]
    
    watch:
      options:
        nospawn: true
        livereload: true

      sass:
        files: '../htdocs/**/*.scss'
        tasks: [
          'sass:dev'
          'autoprefixer:dev'
          # 'newer:sass:dev'
          # 'newer:autoprefixer:dev'
        ]

      static:
        files: [
          '../htdocs/**/*.html'
          '../htdocs/**/*.js'
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
        src: '../htdocs/common/css/*.css'
        options:
          map: false

    image:
      all:
        files: [
          expand: true
          cwd: '../htdocs'
          src: ['**/*.{png,jpg,svg}']
          dest: '../htdocs'
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
      files:
        src: [
          '../htdocs/**/*.css'
          '!../htdocs/common/css/extras/*.css'
        ]

    combine_mq:
      default_options:
        expand: true
        cwd: '../htdocs/path/to/css/'
        src: '*.css'
        dest: '../htdocs/path/to/css/'

    cssmin:
      dist:
        files: [
          expand: true
          src: [
            '../htdocs/**/*.css'
            '!../htdocs/**/*.min.css'
          ]
          ext: '.min.css'
        ]

    xmlsitemap:
      files: ['../htdocs/**/*.html']
      dest: '../test/sitemap.xml'
      options:
        exclude: ['/_scss', '/tmpl']
        host: 'http://' + ip.address() + ':3501'
        base: '../htdocs'

    exec:
      validator:
        cmd: 'export W3C_MARKUP_VALIDATOR_URI=http://`boot2docker ip | sed -e "s/is\:\s([0-9\.]+)$/$1/"`/check && site_validator ../test/sitemap.xml ../test/validation_report.html'

    # newer:
    #   options:
    #     override: checkForModifiedImports

  # Register tasks.
  grunt.registerTask 'default', [
    'sass:dev'
    'autoprefixer:dev'
    'configureProxies'
    'connect'
    'watch'
  ]

  grunt.registerTask 'publish', [
    # 'jshint'
    # 'concat'
    # 'uglify'
    'sass:dist'
    'autoprefixer:dist'
    'csslint'
    'csscomb'
    'combine_mq'
    'cssmin'
    'image:all'
  ]

  grunt.registerTask 'server', [
    'configureProxies'
    'connect:livereload:keepalive'
  ]

  return;
