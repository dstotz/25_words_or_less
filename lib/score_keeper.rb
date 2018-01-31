class ScoreKeeper
  def initialize(teams)
    @teams = teams
    @scores = teams.each_with_object({}) { |team, hash| hash[team.team_name] = 0 }
  end

  def current_scores
    @scores
  end

  def add_point(team_name)
    point_change('add', team_name)
  end

  def remove_point(team_name)
    point_change('subtract', team_name)
  end

  private

  def point_change(add_subtract, team_name, amount = 1)
    if @scores[team_name]
      if add_subtract == 'add'
        @scores[team_name] += 1
      elsif add_subtract == 'subtract'
        @scores[team_name] -= 1
      end
    else
      puts "Unable to find team name: #{team_name}"
    end
  end
end
