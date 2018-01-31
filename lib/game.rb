class Game
  attr_reader :num_teams, :num_players_per_team, :word_picker, :teams, :round_number

  def initialize(num_teams, num_players_per_team)
    @num_teams = num_teams.to_i
    @num_players_per_team = num_players_per_team.to_i
    @word_picker = WordPicker.new
    @started = false
    @teams = []
  end

  def start
    @score_keeper = ScoreKeeper.new(@teams)
    @round_number = 0
    @started = true
  end

  def started?
    @started
  end

  def scores
    @score_keeper.current_scores
  end

  def add_point(team_name)
    @score_keeper.add_point(team_name)
    puts scores
  end

  def remove_point(team_name)
    @score_keeper.remove_point(team_name)
  end

  def add_team(team)
    @teams << team
  end

  def ready_to_start?
    @teams.count >= @num_teams
  end

  def next_round
    @round_number += 1
  end
end
