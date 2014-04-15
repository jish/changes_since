#!/usr/bin/env ruby

# Usage: To get all merged pull requests since v1.37.0
#        script/changes_since v1.37.0

require 'git'
require 'optparse'
require 'set'

class ChangesSince
  def self.fetch(tag, teams=nil, repo=nil)
    options = parse_options
    parser  = CommitParser.new(tag, options)
    commits = parser.parse
    printer = ChangelogPrinter.new(commits, teams, options, repo)
    printer.print!
  end

  def self.parse_options
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: script/changes_since TAG [options]"

      opts.on("-a", "--all", "Consider all interesting commits ([AI-1234] or [ZD#1234] or #bug/public/internal), not just PR merges") do |a|
        options[:all] = a
      end

      opts.on("-s", "--sha", "Include commit sha in the output") do |s|
        options[:sha] = s
      end

      opts.on("-f", "--filter [authors]", "Limit to authors matching the passed string(s). Comma-separated list works.") do |authors|
        options[:author_filter] = authors.split(",")
      end

      opts.on("-t", "--tags", "Group commits by public, internal or bugs") do |t|
        options[:tags] = t
      end

      opts.on("-r", "--risk", "Group commits by high, medium or low risk") do |r|
        options[:risk] = r
      end

      opts.on("-m", "--markdown", "Use tables in Atlassian as markdown") do |m|
        options[:markdown] = m
      end
    end.parse!
    options
  end
end

require 'changes_since/commit_parser'
require 'changes_since/changelog_printer'
