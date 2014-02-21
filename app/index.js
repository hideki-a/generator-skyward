'use strict';
var util = require('util');
var chdir = require('chdir');
var path = require('path');
// var spawn = require('child_process').spawn;
var yeoman = require('yeoman-generator');


var SiteGenerator = module.exports = function SiteGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    // https://github.com/yeoman/generator/issues/282
    chdir('./tools', function () {
      this.installDependencies({ skipInstall: options['skip-install'] });
    }.bind(this));
  });

  this.appPath = process.cwd();

  // this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(SiteGenerator, yeoman.generators.Base);

SiteGenerator.prototype.askFor = function askFor() {
  // welcome message
  console.log(this.yeoman);
};

SiteGenerator.prototype.gruntfile = function gruntfile() {
  this.copy('Gruntfile.coffee', 'tools/Gruntfile.coffee');
};

SiteGenerator.prototype.packageJSON = function packageJSON() {
  this.template('_package.json', 'tools/package.json');
};

SiteGenerator.prototype.rootconfig = function rootconfig() {
  this.copy('gitignore', '.gitignore');
  this.copy('editorconfig', '.editorconfig');
};

SiteGenerator.prototype.bower = function bower() {
  this.copy('bowerrc', 'tools/.bowerrc');
  this.copy('_bower.json', 'tools/bower.json');
};

SiteGenerator.prototype.jshint = function jshint() {
  this.copy('jshintrc', 'tools/.jshintrc');
};

SiteGenerator.prototype.csslint = function csslint() {
  this.copy('csslintrc', 'tools/.csslintrc');
};

SiteGenerator.prototype.stylesheet = function stylesheet() {
  this.directory('sass', 'htdocs/_scss');
  this.template('config.rb', 'tools/config.rb');
};

SiteGenerator.prototype.htmlTmpl = function htmlTmpl() {
  this.copy('index.html', 'htdocs/index.html');
};

SiteGenerator.prototype.app = function app() {
  this.mkdir('htdocs');
  this.mkdir('htdocs/common');
  this.mkdir('htdocs/common/js');
  this.mkdir('htdocs/common/css');
  this.mkdir('htdocs/common/images');
  this.mkdir('materials');
  this.mkdir('backup');
  this.mkdir('test');
  this.mkdir('test/validator');
};
