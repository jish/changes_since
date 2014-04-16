require File.expand_path("../../helper", __FILE__)

class ChangelogPrinterTest < Test::Unit::TestCase

  def stub_commits
    [
      stub(:author => stub(:name => "Rajesh", :email => "rajesh@gmail.com"), :message => "abcd"),
      stub(:author => stub(:name => "Rajesh", :email => "rajesh@gmail.com"), :message => "def #bug"),
      stub(:author => stub(:name => "Ankita", :email => "ankita@gmail.com"), :message => "sad #internal"),
      stub(:author => stub(:name => "Rajesh", :email => "rajesh@gmail.com"), :message => "dasd"),
      stub(:author => stub(:name => "Susan",  :email => "susan@gmail.com"),  :message => "aaaa" ),
      stub(:author => stub(:name => "Rajesh", :email => "rajesh@gmail.com"), :message => "dsss"),
      stub(:author => stub(:name => "Ankita", :email => "ankita@gmail.com"), :message => "ver"),
      stub(:author => stub(:name => "Rajesh", :email => "rajesh@gmail.com"), :message => "sdfs #public"),
      stub(:author => stub(:name => "Derek",  :email => "derek@gmail.com"),  :message => "sds"),
      stub(:author => stub(:name => "Bob",    :email => "bob@gmail.com"),    :message => "bbbb")
    ]
  end

  def stub_teams
    {
      "Team 1" => ["Bob", "Ankita"],
      "Team 2" => ["Rajesh", "susan@gmail.com"]
    }
  end

  context "ChangelogPrinter" do

    context 'initialization' do
      should "setup instance variables" do
        commits = stub
        teams   = stub
        options = stub
        repo    = stub
        printer = ChangesSince::ChangelogPrinter.new(commits, teams, options, repo)
        assert_equal printer.instance_variable_get('@commits'), commits
        assert_equal printer.instance_variable_get('@teams'), teams
        assert_equal printer.instance_variable_get('@options'), options
        assert_equal printer.instance_variable_get('@repo'), repo
      end
    end

    context 'print!' do
      should "print team commits if present" do
        commits = stub
        teams   = stub
        printer = ChangesSince::ChangelogPrinter.new(commits, teams, stub, stub)
        printer.expects(:print_team_commits!)
        printer.print!
      end

      should "print commits if no teams present" do
        commits = stub
        printer = ChangesSince::ChangelogPrinter.new(commits, nil, stub, stub)
        printer.expects(:print_commits!)
        printer.print!
      end
    end

    context "print_team_commits!" do
      setup do
        @commits = stub_commits
        @teams = stub_teams
        @team_commits = {
          "Team 1" => @commits.select { |commit|
            [commit.author.name, commit.author.email].any? { |str| str =~ /Bob|Ankita/i }
          },
          "Team 2" => @commits.select { |commit|
            [commit.author.name, commit.author.email].any? { |str| str =~ /Rajesh|susan@gmail.com/i }
          },
          "Other"  => @commits.select { |commit|
            [commit.author.name, commit.author.email].any? { |str| str =~ /Derek/ }
          }
        }
      end

      should "divide by teams and call print commits" do
        printer = ChangesSince::ChangelogPrinter.new(@commits, @teams, stub, stub)
        @team_commits.each do |name, commit_set|
          printer.expects(:print_team_name).with(name)
          printer.expects(:print_commits!).with(commit_set)
        end
        printer.print_team_commits!
      end

      should "not print other if no commits are present" do
        @commits.reject! { |commit| commit.author.name == "Derek" }
        @team_commits.delete("Other")
        printer = ChangesSince::ChangelogPrinter.new(@commits, @teams, stub, stub)
        @team_commits.each do |name, commit_set|
          printer.expects(:print_team_name).with(name)
          printer.expects(:print_commits!).with(commit_set)
        end
        printer.expects(:print_team_name).with("Other").never
        printer.print_team_commits!
      end
    end

    context "print_commits!" do
      should "call print message for each commit" do
        commits = stub_commits
        options = {}
        printer = ChangesSince::ChangelogPrinter.new(commits, stub, options, stub)
        commits.each { |commit| printer.expects(:print_message).with(commit) }
        printer.print_commits!(commits)
      end

      should "call print message for each commit when tags are enabled" do
        commits = stub_commits
        options = { :tags => true }
        printer = ChangesSince::ChangelogPrinter.new(commits, stub, options, stub)
        untagged_commits = commits.select { |commit| !commit.message =~/[public|bug|internal]/ }
        untagged_commits.each { |commit| printer.expects(:print_message).with(commit) }
        printer.print_commits!(commits)
      end
    end

    context "print_team_name" do
      should "print the team name" do
        printer = ChangesSince::ChangelogPrinter.new(stub, stub, {}, stub)
        printer.expects(:puts).with("\n*abc*\n")
        printer.print_team_name("abc")
      end

      should "print the team name with markdown" do
        printer = ChangesSince::ChangelogPrinter.new(stub, stub, { :markdown => true }, stub)
        printer.expects(:puts).with("||*abc*||Author||PR||")
        printer.print_team_name("abc")
      end
    end
  end
end
