class ChangesSince::ChangelogPrinter
  attr_reader :teams, :options

  def initialize(commits, teams, options)
    @commits = commits
    @teams   = teams
    @options = options
  end

  def print!
    if teams
      print_team_commits!
    else
      print_commits!(@commits)
    end
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
      puts "\n*#{team}*\n"
      print_commits!(team_commits)
    end

    return if @commits.empty?
    puts "\n*Other*\n\n"
    @commits.each { |commit| print_message(commit, nil, options) }
  end

  def print_commits!(output_commits)
    output_commits.sort! { |a, b| a.author.name <=> b.author.name }
    {
      public: 'Public',
      bug: 'Bugs',
      internal: 'Internal'
    }.each do |type, title|
      tagged_commits = output_commits.select { |commit| commit.message.include?("##{type}") }
      next if tagged_commits.empty?

      puts "\n#{title}:\n\n"
      tagged_commits.each { |commit| print_message(commit, type, options) }
      output_commits -= tagged_commits
    end

    puts "\nUnclassified:\n\n"
    output_commits.each { |commit| print_message(commit, nil, options) }
  end

  def print_message(commit, type, options)
    message_lines = commit.message.split("\n\n")
    if message_lines.first =~ /Merge pull request/
      title = message_lines.last
    else
      title = message_lines.first
    end
    title.gsub!("##{type}", "") if type
    branch_author = commit.author.name
    puts "* #{title} (#{branch_author}) #{options[:sha] ? commit.sha[0..9] : ''}"
  end
end
