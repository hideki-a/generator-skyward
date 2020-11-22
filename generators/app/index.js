'use strict';
const Generator = require('yeoman-generator');
const chalk = require('chalk');
const yosay = require('yosay');
const mkdirp = require('mkdirp');
const _ = require("underscore.string");
const path = require("path");

module.exports = class extends Generator {
  prompting() {
    this.pkg = require(path.join(__dirname, "../../package.json"));

    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to the astonishing ' + chalk.red('generator-skyward') + ' generator!'
    ));

    const prompts = [
      {
        type: 'confirm',
        name: 'vscode',
        message: 'Do you use Visual Studio Code?',
        default: true
      },
      {
        type: 'input',
        name: 'themename',
        message: 'Your WordPress theme name. (Enter `n` if you are not using WordPress.)',
        default: _.slugify(this.appname)
      }
    ];

    return this.prompt(prompts).then(props => {
      // To access props later use this.props.someAnswer;
      this.vscode = props.vscode;
      this.themename = props.themename;
    });
  }

  writing() {
    mkdirp.sync('materials');
    mkdirp.sync('backup');
    mkdirp.sync('documents');
    mkdirp.sync('test');
    mkdirp.sync('htdocs/');

    this.fs.copy(
      this.templatePath('src'),
      this.destinationPath('src')
    );
    this.fs.copy(
      this.templatePath('conf'),
      this.destinationPath('conf')
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
      this.templatePath('browserslistrc'),
      this.destinationPath('.browserslistrc')
    );

    if (this.themename !== 'n') {
      this.fs.copy(
        this.templatePath('phpcs.xml'),
        this.destinationPath('phpcs.xml')
      );
    }

    this.fs.copyTpl(
      this.templatePath('_package.json'),
      this.destinationPath('package.json'),
      {
        appname: _.slugify(this.appname),
        htmlDir: this.themename === 'n' ? '/' : '/static/',
        cssDir: this.themename === 'n' ? '/common/css/' : '/wp/wp-content/themes/' + this.themename + '/'
      }
    );
    this.fs.copyTpl(
      this.templatePath('settings_tmpl/_variable.pug'),
      this.destinationPath('src/pug/_partial/_variable.pug'),
      {
        cssDir: this.themename === 'n' ? '/common/css/' : '/wp/wp-content/themes/' + this.themename + '/',
        jsDir: this.themename === 'n' ? '/common/js/' : '/wp/wp-content/themes/' + this.themename + '/js/',
        imageDir: this.themename === 'n' ? '' : '/wp/wp-content/themes/' + this.themename + '/images/'
      }
    );
    this.fs.copyTpl(
      this.templatePath('settings_tmpl/_setting.scss'),
      this.destinationPath('src/scss/_setting.scss'),
      {
        imageDir: this.themename === 'n' ? '' : '/wp/wp-content/themes/' + this.themename + '/images/'
      }
    );
    this.fs.copyTpl(
      this.templatePath('settings_tmpl/bs-config.js'),
      this.destinationPath('conf/bs-config.js'),
      {
        startPath: this.themename === 'n' ? '/' : '/static/'
      }
    );
    this.fs.copyTpl(
      this.templatePath('settings_tmpl/webpack.config.js'),
      this.destinationPath('conf/webpack.config.js'),
      {
        jsDir: this.themename === 'n' ? '/common/js' : '/wp/wp-content/themes/' + this.themename + '/js'
      }
    );
    this.fs.copyTpl(
      this.templatePath('README.md'),
      this.destinationPath('README.md'),
      {
        appname: this.appname,
        version: this.pkg.version
      }
    );

    if (this.vscode) {
      this.fs.copyTpl(
        this.templatePath('_code-workspace'),
        this.destinationPath(_.slugify(this.appname) + '.code-workspace'),
        {
          phpcs: this.themename === 'n' ? 'PSR12' : 'WordPress-Extra'
        }
      );
    }
  }

  install() {
    this.installDependencies({
      yarn: true,
      npm: false,
      bower: false
    });
    this.on('end', () => {
      this.fs.copy(
        'node_modules/normalize.css/normalize.css',
        'src/scss/_normalize.scss'
      );
    });
  }
};
