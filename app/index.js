'use strict';
var path = require('path');
var util = require('util');
var yeoman = require('yeoman-generator');

var SiteGenerator = module.exports = function SiteGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    // http://stackoverflow.com/questions/22361446/yeoman-generator-installing-project-dependencies-in-custom-folder
    // http://stackoverflow.com/questions/18841273/how-to-run-a-grunt-task-after-my-yeoman-generator-finishes-installing
    var approot = process.cwd();
    var npmdir = approot + '/tools';
    process.chdir(npmdir);
    this.installDependencies({
      skipInstall: options['skip-install'],
      callback: function () {
        process.chdir(approot);
      }
    });
  });

  this.appPath = process.cwd();

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(SiteGenerator, yeoman.generators.Base);

SiteGenerator.prototype.askFor = function askFor() {
  // welcome message
  console.log(this.yeoman);

  var done = this.async();
  var prompts = [
    {
      type: 'confirm',
      name: 'sublimetext',
      message: 'Do you use Sublime Text?',
      default: 'Y/n'
    }
  ];

  this.prompt(prompts, function (props) {
    this.sublimetext = props.sublimetext;
    done();
  }.bind(this));
};

SiteGenerator.prototype.taskrunner = function taskrunner() {
  this.copy('Gruntfile.coffee', 'tools_grunt/Gruntfile.coffee');
  this.copy('gulpfile.babel.js', 'tools/gulpfile.babel.js');
  this.copy('babelrc', 'tools/.babelrc');
};

SiteGenerator.prototype.packageJSON = function packageJSON() {
  this.template('_package_grunt.json', 'tools_grunt/package.json');
  this.template('_package.json', 'tools/package.json');
};

SiteGenerator.prototype.rootconfig = function rootconfig() {
  this.copy('gitignore', '.gitignore');
  this.copy('editorconfig', '.editorconfig');
  this.template('README.md', 'README.md');
};

SiteGenerator.prototype.bower = function bower() {
  this.copy('bowerrc', 'tools/.bowerrc');
  this.copy('_bower.json', 'tools/bower.json');
};

SiteGenerator.prototype.eslint = function jshint() {
  this.copy('eslintrc', 'tools/.eslintrc');
};

SiteGenerator.prototype.csslint = function csslint() {
  this.copy('csslintrc', 'tools/.csslintrc');
};

SiteGenerator.prototype.sublime = function sublime() {
  if (this.sublimetext) {
    this.template('_sublime-project', this._.slugify(this.appname) + '.sublime-project');
  }
};

SiteGenerator.prototype.stylesheet = function stylesheet() {
  this.directory('sass', 'htdocs/_scss');
  this.directory('hologramStuff', 'tools_grunt/hologramStuff');
};

SiteGenerator.prototype.script = function script() {
  this.copy('run.js', 'htdocs/common/js/run.js');
};

SiteGenerator.prototype.htmlTmpl = function htmlTmpl() {
  this.directory('include', 'htdocs/include');
  this.copy('index.html', 'htdocs/index.html');
};

SiteGenerator.prototype.app = function app() {
  this.mkdir('htdocs');
  this.mkdir('htdocs/common');
  this.mkdir('htdocs/common/js/components');
  this.mkdir('htdocs/common/css');
  this.mkdir('htdocs/common/css/extra');
  this.mkdir('htdocs/common/images');
  this.mkdir('dist');
  this.mkdir('documents');
  this.mkdir('materials');
  this.mkdir('backup');
  this.mkdir('test');
};
