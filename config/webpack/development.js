// Note: You must restart bin/webpack-dev-server for changes to take effect
const merge = require('webpack-merge')
const sharedConfig = require('./shared.js')
const { settings, output } = require('./configuration.js')
const StyleLintPlugin = require('stylelint-webpack-plugin');

module.exports = merge(sharedConfig, {
  devtool: 'cheap-eval-source-map',

  stats: {
    errorDetails: true
  },

  output: {
    pathinfo: true
  },

  plugins: [
    new StyleLintPlugin({
      configFile: '.stylelintrc',
      context: 'app/assets/stylesheets',
      failOnError: false,
      ignoreFiles: ['**/node_modules/**', '**/admin/**'],
      syntax: 'scss',
    })
  ],

  devServer: {
    clientLogLevel: 'none',
    https: settings.dev_server.https,
    host: settings.dev_server.host,
    port: settings.dev_server.port,
    contentBase: output.path,
    publicPath: output.publicPath,
    compress: true,
    headers: { 'Access-Control-Allow-Origin': '*' },
    historyApiFallback: true,
    watchOptions: {
      ignored: /node_modules/
    }
  }
});
