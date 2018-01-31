class Team
  attr_reader :team_name, :players

  def initialize(team_name, players)
    @team_name = team_name
    @players = players.reject { |e| e.nil? || e == '' }
  end  
end
