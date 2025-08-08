process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const { merge } = require('webpack-merge')
const webpackConfig = require('./base')

module.exports = merge(webpackConfig, {
  mode: 'development',
  devtool: 'cheap-module-source-map'
})