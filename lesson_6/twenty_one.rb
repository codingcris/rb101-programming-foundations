require 'pry'
DECK = [
  ['Diamonds', 'Hearts', 'Spades', 'Clubs'],
  [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'King', 'Queen', 'Ace']
]
TARGET_VALUE = 21
DEALER_TARGET = 17
GRAND_CHAMP_SCORE = 5
FACE_CARDS_VALUE = 10
TITLE = <<-21
 _                      _
| |                    | |
| |___      _____ _ __ | |_ _   _    ___  _ __   ___
| __\\ \\ /\\ / / _ \\ '_ \\| __| | | |  / _ \\| '_ \\ / _ \\
| |_ \\ V  V /  __/ | | | |_| |_| | | (_) | | | |  __/
 \\__| \\_/\\_/ \\___|_| |_|\\__|\\__, |  \\___/|_| |_|\\___|
                            __/ |
                           |___/
                       _____   _____
                      |10 v | |A_ _ |
                      |v v v| |( v )|
                      |v v v| | \\ / |
                      |v v v| |  .  |
                      |___0I| |____V|

21

CLEAR = Gem.win_platform? ? "cls" : "clear"

def prompt(msg)
  puts "=> #{msg}"
end

def deal(player, current_value, dealtcards)
  loop do
    card = [DECK[0].sample, DECK[1].sample]
    unless dealtcards.include?(card)
      player << card_value(card, current_value)
      dealtcards << card
      break
    end
  end
end

def card_value(card, current_value)
  val = card[1]
  if val.is_a? Integer
    val
  else
    case val
    when "Ace" then if current_value + 11 > TARGET_VALUE
                      1
                    else
                      11
                    end
    else FACE_CARDS_VALUE
    end
  end
end

def display_cards(player, dealer)
  prompt "Dealer has: #{dealer[0]} and an unknown card."
  prompt "You have: #{join_cards(player)}"
end

def join_cards(deck)
  case deck.length
  when 1 then deck[0].to_s
  when 2 then "#{deck[0]} and #{deck[1]}"
  else deck.slice(0...deck.length - 1).join(", ") + " and #{deck.last}"
  end
end

def player_choose_move
  move = ''
  loop do
    prompt "Hit or stay?"
    move = gets.chomp.downcase
    break if move == 'hit' || move == 'stay'
    prompt "Invalid choice. Enter 'hit' or 'stay'."
  end
  move
end

def dealer_choose_move(deck_value)
  move = if deck_value < DEALER_TARGET
           'hit'
         else
           'stay'
         end
  move
end

def busted?(deck_value, *player_id)
  unless player_id.empty?
    display_bust(player_id[0]) if deck_value > TARGET_VALUE
  end
  deck_value > TARGET_VALUE
end

def display_bust(player)
  prompt "#{player} exceeds #{TARGET_VALUE}! That's a bust."
  case player
  when 'Player' then prompt "You lose."
  else prompt "You win!"
  end
end

def compare_decks(player, dealer)
  comparison = player <=> dealer
  case comparison
  when -1 then display_win('Dealer')
  when 1 then display_win('Player')
  else display_win('Tie')
  end
  comparison
end

def display_win(winner)
  case winner
  when 'Tie' then
    prompt "Player and dealer decks are equal in value. It's a draw!"
  when "Player = #{TARGET_VALUE}" then
    prompt "You reached #{TARGET_VALUE}! You win!"
  when "Dealer = #{TARGET_VALUE}" then
    prompt "Dealer reached #{TARGET_VALUE}! You lose."
  else prompt "#{winner} was closest to #{TARGET_VALUE}. #{winner} wins!"
  end
end

def display_decks(player, dealer)
  puts "------------------------------------"
  prompt "Your deck: #{join_cards(player)}"
  prompt "Dealer deck: #{join_cards(dealer)}"
  puts "------------------------------------"
end

def display_score(player, dealer)
  prompt "SCORE: YOU => #{player} ; DEALER => #{dealer}"
end

def display_grand_champ(player, dealer)
  if player == GRAND_CHAMP_SCORE
    prompt "YOU ARE GRAND CHAMPION!!!"
  elsif dealer == GRAND_CHAMP_SCORE
    prompt "DEALER IS GRANDCHAMPION. BETTER LUCK NEXT TIME!"
  end
  display_score(player, dealer)
  sleep(3)
end

def play_again?(round_or_game)
  again = case round_or_game
          when 'round' then "next round"
          else "again"
          end
  answer = ''
  loop do
    prompt "Do you want to play #{again}? (Y/N)"
    answer = gets.chomp
    if answer.downcase == 'y' || answer.downcase == 'n'
      break
    else
      prompt "Invalid choice. Only y or n accepted."
    end
  end
  prompt "Thanks for playing!" unless answer.downcase == 'y'
  answer.downcase == 'y'
end

player_wins = 0
dealer_wins = 0

loop do
  if player_wins == 5 || dealer_wins == 5
    player_wins = 0
    dealer_wins = 0
  end

  system(CLEAR)
  puts TITLE
  prompt "First to 5 is grand champ!"
  display_score(player_wins, dealer_wins)
  sleep(3)

  winner = false
  player = []
  player_value = 0

  dealer = []
  dealer_value = 0

  dealtcards = []
  system(CLEAR)

  2.times do
    deal(player, player_value, dealtcards)
    player_value += player.last

    deal(dealer, dealer_value, dealtcards)
    dealer_value += dealer.last
  end

  loop do
    display_cards(player, dealer)

    if player_value == TARGET_VALUE
      player_wins += 1
      display_win("Player = #{TARGET_VALUE}")
      display_decks(player, dealer)
      winner = true
      break
    else
      move = player_choose_move
    end
    prompt "You chose to #{move}"
    sleep(1)
    system(CLEAR)
    break if move == 'stay'

    deal(player, player_value, dealtcards)
    player_value += player.last

    if busted?(player_value, 'Player')
      dealer_wins += 1
      display_decks(player, dealer)
      break
    end
  end

  unless busted?(player_value) || winner
    prompt "Dealer's turn."
    prompt "Dealer is taking his sweet time..."
    sleep(3)
    system(CLEAR)
    loop do
      if dealer_value == TARGET_VALUE
        dealer_wins += 1
        display_win("Dealer = #{TARGET_VALUE}")
        display_decks(player, dealer)
        break
      else
        move = dealer_choose_move(dealer_value)
      end

      if move == 'hit'
        deal(dealer, dealer_value, dealtcards)
        dealer_value += dealer.last
      else
        result = compare_decks(player_value, dealer_value)
        case result
        when 1 then player_wins += 1
        when -1 then dealer_wins += 1
        end
        display_decks(player, dealer)
        break
      end
      if busted?(dealer_value, 'Dealer')
        player_wins += 1
        display_decks(player, dealer)
        break
      end
    end
  end
  if player_wins == GRAND_CHAMP_SCORE || dealer_wins == GRAND_CHAMP_SCORE
    display_grand_champ(player_wins, dealer_wins)
    break unless play_again?('game')
  end

  if player_wins < GRAND_CHAMP_SCORE && dealer_wins < GRAND_CHAMP_SCORE
    break unless play_again?('round')
  end
end
