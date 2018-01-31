function refresh_words() {
  $('#words').fadeOut(function() {
    $.get('new-words', function(data){
      $('#words').html(data);
    });
  });
  $('#words').fadeIn(show_words)
}

function toggle_hide_words() {
  if ($('#words').css('opacity') == "1") {
    hide_words();
  } else {
    show_words();
  };
}

function timer_selection_to_seconds() {
  val = $('#timer-selection').val()
  if (val == "30 Seconds") {
    return 30
  } else if (val == "1 Minute") {
    return 60
  } else if (val == "2 Minutes") {
    return 120
  } else if (val == "3 Minutes") {
    return 180
  } else if (val == "5 Minutes") {
    return 300
  }
}

function team_selected() {
  $('#team-buttons').hide(500)
  $('#set-bidding').show(500)
}

function collect_round_results() {
  $('#set-bidding').hide(500)
  $('#round-outcome').show(500)
  $('#current-score').show(500)
  $('#current-round').show(500)
}

function clock_started() {
  $('#current-score').hide(500)
  $('#current-round').hide(500)
}

function round_success() {
  add_point()
  $('#round-outcome').hide(500)
  $('#team-buttons').show(500)
}

function round_fail() {
  remove_point()
  $('#round-outcome').hide(500)
  $('#team-buttons').show(500)
}

function hide_words() {
  $("#words").animate({ duration: 1000, opacity: 0 })
}

function show_words() {
  $("#words").css('opacity', '100');
}

function toggle_score_team() {
  if ($('#current-score .score-list').html()) {
    $.get('current-players', function(data){
      $('#current-score').html(data);
    });
  } else {
    $.get('current-score', function(data){
      $('#current-score').html(data);
    });
  };
}

function update_score() {
  if ($('#current-score .score-list').html()) {
    $.get('current-score', function(data){
      $('#current-score').html(data);
    });
  };
}

function update_round() {
  $.get('current-round', function(data){
    $('#team-scores').html(data);
  });
}

function update_team() {
  $.get('current-team', function(data){
    $('#current-team').html(data);
  });
}

function start_game_updater() {
  setInterval(function(){
    update_score();
    update_round();
    update_team();
  },1500);  
}

function start_round_clock() {
  var seconds = timer_selection_to_seconds()
  clock = $('#round-clock').FlipClock(seconds, {
    countdown: true,
    clockFace: 'MinuteCounter',
    autoStart: true,
    callbacks: {
      stop: function() {
        // document.getElementById('alert-sound').play();
        collect_round_results()
        $('#round-clock').hide()
      },
      start: function() {
        clock_started()
      }
    }
  });
  $('#round-clock').show()
}

function set_active_team(button) {
  var team_name = button.currentTarget.textContent;
  $.post('set-active-team?team_name=' + team_name);
  team_selected()
}

function add_point() {
  $.post('add-point')
}

function remove_point() {
  $.post('remove-point')
}

function stop_round_clock() {
  var seconds = timer_selection_to_seconds()
  collect_round_results()
  clock = $('#round-clock').FlipClock(seconds, {
    countdown: true,
    clockFace: 'MinuteCounter',
    autoStart: false,
  });
  $('#round-clock').hide()
}