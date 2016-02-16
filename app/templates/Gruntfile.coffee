'use strict'

module.exports = (grunt) ->
  require('jit-grunt') grunt,
    replace: 'grunt-text-replace'
  grunt.loadNpmTasks 'grunt-notify'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    exec:
      hologram_pc:
        cmd: '(cd hologramStuff; bundle exec hologram config.yml; cd ../)'
      hologram_sp:
        cmd: '(cd hologramStuff; bundle exec hologram config_sp.yml; cd ../)'

    # Settings for Hologram
    replace:
      styleguide_css_pc:
        src: ['../docs/styleguide/common/css/*.css']
        dest: '../docs/styleguide/common/css/'
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
        src: ['../docs/styleguide/*.html']
        dest: '../docs/styleguide/'
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
  grunt.registerTask 'styleguide', [
    'exec:hologram_pc'
    'replace:styleguide_css_pc'
    'replace:styleguide_html_pc'
  ]

  grunt.registerTask 'styleguide_sp', [
    'exec:hologram_sp'
    'replace:styleguide_css_sp'
    'replace:styleguide_html_sp'
  ]
  return;
