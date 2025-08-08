process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const { merge } = require('webpack-merge')
const webpackConfig = require('./base')

module.exports = merge(webpackConfig, {
  mode: 'production'
})