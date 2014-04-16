module ChangesSince
  class ChangelogPrinter
    attr_reader :teams, :options, :repo

    TAGS = {
      :public   => 'Public',
      :bug      => 'Bugs',
      :internal => 'Internal'
    }

    def initialize(commits, teams, options, repo)
      @commits = commits
      @teams   = teams
      @options = options
      @repo    = repo
    end

    def print!
      if teams
        print_team_commits!
      else
        print_commits!(@commits)
      end
      return
    end

    def print_team_commits!
      teams.each do |team, members|
        author_re = /#{members.join("|")}/i
        team_commits = @commits.select do |commit|
          [commit.author.name, commit.author.email].any? do |str|
            str =~ author_re
          end
        end
        next if team_commits.empty?
        @commits -= team_commits
        print_team_name(team)
        print_commits!(team_commits)
      end

      return if @commits.empty?
      print_team_name("Other")
      print_commits!(@commits)
    end

    def print_team_name(name)
      if options[:markdown]
        row = "||*#{name}*||Author||PR||"
        row << "Commit||" if options[:sha]
        row << "Risks||" if options[:risks]
        puts row
      else
        puts "\n*#{name}*\n"
      end
    end

    def print_commits!(output_commits)
      output_commits.sort! { |a, b| a.author.name <=> b.author.name }

      if options[:tags]
        TAGS.each do |type, title|
          tagged_commits = output_commits.select { |commit| commit.message.include?("##{type}") }
          next if tagged_commits.empty?

          puts "\n#{title}:\n\n"
          tagged_commits.each { |commit| print_message(commit, type) }
          output_commits -= tagged_commits
        end
        return if output_commits.empty?
        puts "\nUnclassified:\n\n"
      end

      output_commits.each { |commit| print_message(commit) }
    end

    def print_message(commit, tag=nil)
      message_lines = commit.message.split("\n\n")
      if message_lines.first =~ /Merge pull request/
        title = message_lines.last
        pr    = message_lines.first.split(" from ").first.split("#").last
      else
        title = message_lines.first
        sha   = options[:sha] ? commit.sha[0..9] : ''
      end
      title.gsub!("##{tag}", "") if tag
      branch_author = commit.author.name
      if options[:markdown]
        text = "|#{title}|"
        text << "#{branch_author}|"
        text << "[##{pr}|#{@repo}/pull/#{pr}]|" if @repo && pr
        text << "[#{sha}|#{@repo}/commit/#{sha}]|" if sha
        text << "|" if options[:risks]
      else
        text = "* #{title} (#{branch_author})"
      end
      puts text
    end
  end
end
