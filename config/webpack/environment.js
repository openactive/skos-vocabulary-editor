const { environment } = require('@rails/webpacker')
const path = require('path')

const babelLoader = environment.loaders.get('babel')

// Explicitly include app/javascript and jqtree module for babel transpiling
babelLoader.include = [
  path.resolve(__dirname, '../../app/javascript'),
  path.resolve(__dirname, '../../node_modules/jqtree'),
]

module.exports = environment
