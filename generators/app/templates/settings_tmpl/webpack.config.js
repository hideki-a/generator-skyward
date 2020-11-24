// Referenced
// https://ics.media/entry/16028/
// https://developer.cybozu.io/hc/ja/articles/360022880491-webpack%E5%85%A5%E9%96%80-Babel-Polyfill%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E5%BF%AB%E9%81%A9ES6%E3%83%A9%E3%82%A4%E3%83%95-
const path = require('path');

module.exports = {
  mode: 'development',

  entry: {
    // 'polyfill': '@babel/polyfill',
    'main': './src/js/main.js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        use: [
          {
            loader: 'babel-loader',
            options: {
              presets: [
                '@babel/preset-env'
              ],
              plugins: [
                '@babel/plugin-proposal-class-properties'
              ]
            }
          }
        ]
      }
    ]
  },
  output: {
    path: path.resolve(__dirname, '../htdocs<%= jsDir %>'),
    filename: '[name].js'
  }
};
