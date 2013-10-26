'use strict'
LIVERELOAD_PORT = 35729
lrSnippet = require('connect-livereload')({ port: LIVERELOAD_PORT })
proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest
mountFolder = (connect, dir) ->
  return connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    compass:
      dev:
        reference:
          '../htdocs/common/css': '../htdocs/_scss'
          '../htdocs/category/css': '../htdocs/category/_scss'
        options:
          config: 'config.rb'
          environment: 'development'

      dist:
        reference: '<%= compass.dev.reference %>'
        options:
          config: 'config.rb'
          environment: 'production'
          force: true

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
          open: 'http://localhost:<%= connect.livereload.options.port %>'
      proxies: [
        context: '/contact'
        host: '<%= pkg.name %>.localhost'
        changeOrigin: true
      ]
    
    watch:
      options:
        nospawn: true
        livereload: true

      compass:
        files: '../htdocs/**/*.scss'
        tasks: ['compass:dev']

      static:
        files: [
          '../htdocs/**/*.html'
          '../htdocs/**/*.js'
        ]

    imageoptim:
      files: ['../htdocs']
      options:
        jpegMini: false
        imageAlpha: false,
        quitAfter: true

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
        cmd: 'site_validator test/sitemap.xml test/validator/report.html'

    growl:
      notify: true

  # Load grunt tasks.
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # Register tasks.
  grunt.registerTask 'default', [
    'compass:dev'
    'configureProxies'
    'connect'
    'watch'
  ]

  grunt.registerTask 'publish', [
    # 'jshint'
    # 'concat'
    # 'uglify'
    'csslint'
    'csscomb'
    'cmq'
    'cssmin'
    'imageoptim'
  ]

  grunt.registerTask 'server', ['connect:livereload:keepalive']

  return;