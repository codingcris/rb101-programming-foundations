VALID_CHOICES = %w(rock paper scissors lizard spock)
ROCK_ASCII = <<-ROCK
        ____
---'        )
      (_____)
      (_____)
      (____)
---.__(___)
ROCK

PAPER_ASCII = <<-PAPER
    _______
---'   ____)____
          ______)
           _______)
          _______)
---.__________)
PAPER

SCISSORS_ASCII = <<-SCISSORS
    _______
---'   ____)____
          ______)
       __________)
      (____)
---.__(___)
SCISSORS

LIZARD_ASCII = <<-LIZARD
                       )/_
             _.--..---"-,--c_
        \L..'           ._O__)_
,-.     _.+  _  \..--( /
  `\.-''__.-' \ (     \_
    `'''       `\__   /\
                ')
LIZARD

VULCAN_SALUTE_ASCII = <<-VULC
             ( ,    % % /
           * % %   *  , %
           * %  . .#..  %
           .  %/% *  %  (
            # %  %% .% ..
            % %        *
            &          ..
            #     % ,   ,   ,,/#
           ..            %.  * %
           .      .        /*
            %    %      .%
            *         (*
             #%*#%%/&
VULC

WINNERS = {
  rock: ['scissors', 'lizard'],
  paper: ['rock', 'spock'],
  scissors: ['paper', 'lizard'],
  lizard: ['paper', 'spock'],
  spock: ['scissors', 'rock']
}
CLEAR = Gem.win_platform? ? "cls" : "clear"

def display_game_animation
  system(CLEAR)
  puts "READY?"
  sleep(0.5)

  puts 'ROCK!'
  puts ROCK_ASCII
  sleep(0.5)
  system(CLEAR)

  puts 'PAPER!'
  puts PAPER_ASCII
  sleep(0.5)
  system(CLEAR)

  puts 'SCISSORS!'
  puts SCISSORS_ASCII
  sleep(0.5)
  system(CLEAR)

  puts "LIZARD?!"
  puts LIZARD_ASCII
  sleep(0.5)
  system(CLEAR)

  puts "SPOCK??!"
  puts VULCAN_SALUTE_ASCII
  sleep(0.5)
  system(CLEAR)
end

def prompt(message)
  puts "=> #{message}"
end

def print_invalid(calling_id)
  prompt "Invalid choice."
  case calling_id
  when 'y/n' then prompt "Only 'Y' / 'N' accepted"
  when 'choice' then prompt "Enter 'R' for rock. Enter 'P' for paper. \
Enter 'S' for scissors. Enter 'L' for lizard. Enter 'SP' for spock."
  end
end

def display_choices
  prompt "Choose one: #{VALID_CHOICES.join(', ')} (R,P,S,L,SP)"
end

def choice
  loop do
    display_choices
    user_choice = gets.chomp.downcase.delete(" \t\n\r")
    if !user_choice.empty? &&
       user_choice.length <= 2 &&
       (user_choice = VALID_CHOICES.select { |c| c.start_with?(user_choice) }[0])
      return user_choice
    else print_invalid('choice')
    end
  end
end

def win?(first, second)
  WINNERS[first.to_sym].include?(second)
end

def results(player, computer)
  if win?(player, computer)
    "You win!"
  elsif win?(computer, player)
    "Computer wins!"
  else
    "It's a tie!"
  end
end

def print_play_on_question(player_wins, computer_wins)
  prompt player_wins.to_i < 5 && computer_wins.to_i < 5 ? "Proceed to next round?(Y/N)" :
"Want to play again?(Y/N)"
end

def again?(player_wins, computer_wins)
  response = ''
  loop do
    print_play_on_question(player_wins, computer_wins)
    response = gets.chomp.downcase
    if response != 'y' && response != 'n'
      print_invalid('y/n')
    else break
    end
  end
  update_score(true, player_wins, computer_wins) if(player_wins.to_i == 5 || computer_wins.to_i == 5)
  response == 'y'
end

def update_score(clear, *wins)
  unless clear
    current_wins = wins[0].to_i
    wins[0].clear
    wins[0] << (current_wins + 1).to_s
  else
    wins[0].clear
    wins[0] << '0'
    wins[1].clear
    wins[1] << '0'
  end
end

def display_score(player, computer)
  if player.to_i < 5 && computer.to_i < 5
    prompt "Current Score : You -> #{player} ; Computer -> #{computer}"
  else
    prompt player.to_i > computer.to_i ? "Final score #{player} to #{computer}. You're th\
e Grand Champion!" : "Final score #{computer} to #{player}. Computer is the \
Grand Champion!"
  end
end

player_wins = '0'
computer_wins = '0'
loop do
  display_game_animation
  user_choice = choice
  computer_choice = VALID_CHOICES.sample

  prompt "You chose #{user_choice}; Computer chose #{computer_choice}."

  result = results(user_choice, computer_choice)
  prompt result

  if result == 'You win!'
    update_score(false,player_wins)
  elsif result == 'Computer wins!'
    update_score(false,computer_wins)
  end

  display_score(player_wins, computer_wins)
#reset score incase player wants to play again

unless again?(player_wins, computer_wins)
  prompt "Thanks for playing!"
  break
end

end
