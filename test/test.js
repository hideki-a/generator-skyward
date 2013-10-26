/*global describe, beforeEach, it*/

var path    = require('path');
var helpers = require('yeoman-generator').test;
var assert  = require('assert');


describe('Website generator test', function () {
  beforeEach(function (done) {
    helpers.testDirectory(path.join(__dirname, 'temp'), function (err) {
      if (err) {
        return done(err);
      }

      this.skyward = helpers.createGenerator('skyward:app', [
        '../../app', [
          helpers.createDummyGenerator(),
          'mocha:app'
        ]
      ]);
      done();
    }.bind(this));
  });

  it('the generator can be required without throwing', function () {
    // not testing the actual run of generators yet
    this.app = require('../app');
  });

  it('creates expected files', function (done) {
    var expected = [
      'tools/bower.json',
      'tools/package.json',
      'tools/Gruntfile.coffee',
      'htdocs/_scss/basic.scss'
    ];

    this.skyward.options['skip-install'] = true;
    this.skyward.run({}, function () {
      helpers.assertFiles(expected);
      done();
    });
  });
});
