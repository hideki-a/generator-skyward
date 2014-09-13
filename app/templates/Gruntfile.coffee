'use strict'
LIVERELOAD_PORT = 35729
lrSnippet = require('connect-livereload')({ port: LIVERELOAD_PORT })
proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest
checkForModifiedImports = require('./lib/grunt-newer-util').checkForModifiedImports
mountFolder = (connect, dir) ->
  return connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    sass:
      options:
        # sourcemap: none
        compass: true
        precision: 3

      default:
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
          'newer:sass:default'
          'newer:autoprefixer:dist'
        ]

      static:
        files: [
          '../htdocs/**/*.html'
          '../htdocs/**/*.js'
        ]

    autoprefixer:
      options:
        browser: [
          'last 2 version'
          'Firefox ESR'
          'ie 9'
          'ie 8'
        ]
        map: true
      dist:
        src: '../htdocs/common/css/*.css'

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
        'path/to/script.js'
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

    cmq:
      dist:
        files:
          '../htdocs/path/to/css/' : ['../htdocs/path/to/*.css']    # Overwriting

    cssmin:
      dist:
        files: [
          expand: true
          src: ['../htdocs/**/*.css']
        ]

    xmlsitemap:
      files: ['../htdocs/**/*.html']
      dest: '../test/sitemap.xml'
      options:
        exclude: ['/_scss', '/tmpl']
        host: 'http://foo.localhost'
        base: '../htdocs'

    exec:
      validator:
        cmd: 'env W3C_MARKUP_VALIDATOR_URI=http://`boot2docker ip | sed -e "s/is\:\s([0-9\.]+)$/$1/"`/check site_validator ../test/sitemap.xml ../test/validation_report.html'

    newer:
      options:
        override: checkForModifiedImports

  # Load grunt tasks.
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)
  grunt.loadNpmTasks 'grunt-image'

  # Register tasks.
  grunt.registerTask 'default', [
    'newer:sass:default'
    'newer:autoprefixer:dist'
    'configureProxies'
    'connect'
    'watch'
  ]

  grunt.registerTask 'imagemin', [
    'newer:image:all'
  ]

  grunt.registerTask 'publish', [
    # 'jshint'
    # 'concat'
    # 'uglify'
    'csslint'
    'csscomb'
    'cmq'
    'cssmin'
    'newer:image:all'
  ]

  grunt.registerTask 'server', [
    'configureProxies'
    'connect:livereload:keepalive'
  ]

  return;
