class ChangesSince::CommitParser
  attr_reader :log, :options

  def initialize(tag, options)
    git  = Git.open(Dir.pwd)
    @log = git.log(100000).between(tag)
    @options = options
  end

  def parse_all_commits
    interesting = Set.new
    all_commits = log.to_a

    link_re = /^\s*\[(.*?)\]/m
    linked_commits, remaining_commits = all_commits.partition do |commit|
      commit.message =~ link_re
    end

    linked_commits.uniq! do |commit|
      commit.message[link_re,1]
    end

    interesting = interesting + linked_commits

    interesting_re = /
      (?:\#(bug|public|internal)) | # anything explicitly tagged
      (?:closes\s\#\d+) | # a squash-merge commit closing the linked PR
      (?:Merge\spull\srequest) # a straight PR merge
    /xmi

    remaining_commits.each do |commit|
      if commit.message =~ interesting_re
        interesting << commit
      end
    end
    commits = interesting.to_a
  end

  def parse
    commits = if options[:all]
      parse_all_commits
    else
      log.select { |commit| commit.message =~ /Merge pull request/ }
    end

    if options[:author_filter]
      author_re = /#{options[:author_filter].join("|")}/i
      commits = commits.select do |commit|
        [commit.author.name, commit.author.email].any? do |str|
          str =~ author_re
        end
      end
    end
  end
end
