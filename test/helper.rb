require 'bundler'
require 'test/unit'
require 'mocha'
require 'mocha/test_unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'changes_since'
