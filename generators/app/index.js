'use strict';
const Generator = require('yeoman-generator');
const chalk = require('chalk');
const yosay = require('yosay');
const mkdirp = require('mkdirp');
const _ = require("underscore.string");
const wiring = require("html-wiring");
const path = require("path");

module.exports = class extends Generator {
  prompting() {
    this.pkg = JSON.parse(wiring.readFileAsString(path.join(__dirname, "../../package.json")));

    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to the astonishing ' + chalk.red('generator-skyward') + ' generator!'
    ));

    const prompts = [{
      type: 'confirm',
      name: 'sublimetext',
      message: 'Do you use Sublime Text?',
      default: true
    }];

    return this.prompt(prompts).then(props => {
      // To access props later use this.props.someAnswer;
      this.sublimetext = props.sublimetext;
    });
  }

  writing() {
    mkdirp.sync('tools');
    mkdirp.sync('tools_grunt');
    mkdirp.sync('materials');
    mkdirp.sync('backup');
    mkdirp.sync('documents');
    mkdirp.sync('test');
    mkdirp.sync('htdocs/_scss');
    mkdirp.sync('htdocs/common/js/components');
    mkdirp.sync('htdocs/common/css/extra');
    mkdirp.sync('htdocs/common/images');

    this.fs.copy(
      this.templatePath('sass'),
      this.destinationPath('htdocs/_scss')
    );
    this.fs.copy(
      this.templatePath('include'),
      this.destinationPath('htdocs/include')
    );
    this.fs.copy(
      this.templatePath('hologramStuff'),
      this.destinationPath('tools_grunt/hologramStuff')
    );
    this.fs.copy(
      this.templatePath('Gruntfile.coffee'),
      this.destinationPath('tools_grunt/Gruntfile.coffee')
    );
    this.fs.copy(
      this.templatePath('gulpfile.babel.js'),
      this.destinationPath('tools/gulpfile.babel.js')
    );
    this.fs.copy(
      this.templatePath('babelrc'),
      this.destinationPath('tools/.babelrc')
    );
    this.fs.copy(
      this.templatePath('gitignore'),
      this.destinationPath('.gitignore')
    );
    this.fs.copy(
      this.templatePath('editorconfig'),
      this.destinationPath('.editorconfig')
    );
    this.fs.copy(
      this.templatePath('browserslist'),
      this.destinationPath('browserslist')
    );
    this.fs.copy(
      this.templatePath('bowerrc'),
      this.destinationPath('tools/.bowerrc')
    );
    this.fs.copy(
      this.templatePath('eslintrc'),
      this.destinationPath('tools/.eslintrc')
    );
    this.fs.copy(
      this.templatePath('csslintrc'),
      this.destinationPath('tools/.csslintrc')
    );
    this.fs.copy(
      this.templatePath('run.js'),
      this.destinationPath('htdocs/common/js/run.js')
    );
    this.fs.copy(
      this.templatePath('index.html'),
      this.destinationPath('htdocs/index.html')
    );
    this.fs.copy(
      this.templatePath('prettifyrc'),
      this.destinationPath('tools_grunt/.prettifyrc')
    );

    this.fs.copyTpl(
      this.templatePath('_package.json'),
      this.destinationPath('tools/package.json'),
      { appname: _.slugify(this.appname) }
    );
    this.fs.copyTpl(
      this.templatePath('_package_grunt.json'),
      this.destinationPath('tools_grunt/package.json'),
      { appname: _.slugify(this.appname) }
    );
    this.fs.copyTpl(
      this.templatePath('README.md'),
      this.destinationPath('README.md'),
      { appname: this.appname, pkg: this.pkg }
    );
    this.fs.copyTpl(
      this.templatePath('_bower.json'),
      this.destinationPath('tools/bower.json'),
      { appname: _.slugify(this.appname) }
    );

    if (this.sublimetext) {
      this.fs.copyTpl(
        this.templatePath('_sublime-project'),
        this.destinationPath(_.slugify(this.appname) + '.sublime-project'),
        { appPath: this.contextRoot }
      );
    }
  }

  install() {
    var self = this;
    process.chdir('tools');
    this.installDependencies({
      yarn: true,
      npm: false,
      bower: true,
      skipInstall: this.options["skip-install"],
      callback: function () {
        if (!self.options["skip-install"]) {
          self.fs.copy(
            'node_modules/normalize.css/normalize.css',
            '../htdocs/_scss/_normalize.scss'
          );
        }
      }
    });
  }
};
