require 'bundler'
require 'test/unit'
require 'mocha'
require 'mocha/test_unit'
require 'shoulda'
require 'debugger'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
