/*global describe, beforeEach, it*/

var path = require('path');
var assert = require('yeoman-generator').assert;
var helpers = require('yeoman-generator').test;
var os = require('os');

describe('test:app', function () {
  before(function (done) {
    helpers.run(path.join(__dirname, '../app'))
      .inDir(path.join(os.tmpdir(), './temp'))
      .withOptions({ 'skip-install': true })
      .withPrompt({
        sublimetext: 'Y'
      })
      .on('end', done);
  });

  it('creates files', function () {
    assert.file([
      '.editorconfig',
      'tools/bower.json',
      'tools/package.json',
      'tools/Gruntfile.coffee',
      'htdocs/_scss/basic.scss',
      'htdocs/index.html'
    ]);
  });
});
