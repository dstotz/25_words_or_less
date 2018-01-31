require 'sinatra'
require 'puma'
require 'securerandom'
Dir['./lib/*.rb'].each { |f| require f }

enable :sessions
set :session_secret, SecureRandom.hex(64)
set :server, 'puma'
set :logging, nil

$game = {}

def initialize_test_game
  $game[session.id] = Game.new(3, 2)
  $game[session.id].add_team(Team.new('pandas', ['derek', 'rachel']))
  $game[session.id].add_team(Team.new('kangaroos', ['dan', 'kasey']))
  $game[session.id].add_team(Team.new('crocodiles', ['jay', 'libby']))
  $game[session.id].add_team(Team.new('badgers', ['wes', 'emily']))
end

get '/' do
  # initialize_test_game
  erb :index
end

get '/word-generator' do
  if $game[session.id].nil?
    $game[session.id] = Game.new(0, 0)
    $game[session.id].start
  end
  erb :word_generator
end

get '/new-game' do
  $game[session.id] = nil
  erb :new_game
end

get '/resume-game' do
  if $game[session.id].num_teams == 0
    redirect '/word-generator'
  else
    redirect '/game'
  end
end

post '/new-game' do
  $game[session.id] = Game.new(params['number-of-teams'], params['players-per-team'])
  redirect '/new-team'
end

get '/new-team' do
  redirect '/' if $game[session.id].nil?
  redirect '/game' if $game[session.id].ready_to_start?
  erb :new_team
end

post '/new-team' do
  redirect '/' if $game[session.id].nil?
  players = $game[session.id].num_players_per_team.times.map { |i| params["player#{i}"] }
  team = Team.new(params['team-name'], players)
  $game[session.id].add_team(team)
  redirect '/new-team'
end

get '/rules' do
  send_file './public/resources/rules.pdf', type: :pdf
end

get '/game' do
  redirect '/' if $game[session.id].nil?
  redirect '/new-team' unless $game[session.id].ready_to_start?
  $game[session.id].start unless $game[session.id].started?
  erb :game
end

post '/set-active-team' do
  session[:active_team] = params['team_name']
end

post '/add-point' do
  team_name = session[:active_team]
  $game[session.id].add_point(team_name)
  $game[session.id].next_round
end

post '/remove-point' do
  team_name = session[:active_team]
  $game[session.id].remove_point(team_name)
  $game[session.id].next_round
end

get '/new-words' do
  erb :'partial/new_words'
end

get '/current-score' do
  erb :'partial/current_score'
end

get '/current-team' do
  erb :'partial/current_team'
end

get '/current-round' do
  erb :'partial/current_round'
end

get '/current-players' do
  erb :'partial/current_players'
end
