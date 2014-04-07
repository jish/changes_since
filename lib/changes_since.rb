#!/usr/bin/env ruby

# Usage: To get all merged pull requests since v1.37.0
#        script/changes_since v1.37.0

require 'git'
require 'optparse'
require 'set'

class ChangesSince
  def self.fetch(tag, options, teams=nil)
    parser  = CommitParser.new(tag, options)
    commits = parser.parse
    printer = ChangelogPrinter.new(commits, teams, options)
    printer.print!
  end
end
