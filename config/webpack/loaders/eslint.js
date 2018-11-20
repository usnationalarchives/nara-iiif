module.exports = {
  enforce: 'pre',
  test: /\.js(\.erb)?$/,
  exclude: /node_modules|javascript\/lib/,
  use: 'eslint-loader',
  // Note: The options below didn’t seem to have any effect
  // loader: 'eslint-loader',
  // options: {
  //   emitError: true,
  //   emitWarning: true,
  //   failOnWarning: false,
  //   failOnError: false,
  // }
}
