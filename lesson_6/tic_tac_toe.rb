INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
CLEAR = Gem.win_platform? ? "cls" : "clear"
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals
COIN = ['heads', 'tails']

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/MethodLength
def choose
  prompt "Coin toss will determine who goes first."
  choice = ''
  loop do
    prompt "Choose heads or tails (H/T)"
    choice = gets.chomp.downcase
    break if choice == 'h' || choice == 't'
    prompt "Invalid choice. Enter 'H' for heads or 'T' for tails."
  end
  winner = COIN.sample
  first = if winner.start_with?(choice)
            'player'
          else
            'computer'
          end
  prompt "You chose #{COIN.select { |side| side.start_with?(choice) }[0]}.\
 Coin landed on #{winner}. #{first.capitalize} goes first."
  sleep(3)
  first
end
# rubocop:enable Metrics/MethodLength

def initialize_board
  board = {}
  (1..9).each { |num| board[num] = INITIAL_MARKER }
  board
end

def display_board(board_vals)
  system(CLEAR)
  prompt "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  prompt "First to 5 wins"
  board = <<-BOARD
     |     |
  #{board_vals[1]}  |  #{board_vals[2]}  |  #{board_vals[3]}
_____|_____|_____
     |     |
  #{board_vals[4]}  |  #{board_vals[5]}  |  #{board_vals[6]}
_____|_____|_____
     |     |
  #{board_vals[7]}  |  #{board_vals[8]}  |  #{board_vals[9]}
     |     |
BOARD

  puts board
end

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

# rubocop:disable Lint/UselessAssignment
def joinor(board)
  str = if board.length > 1
          board.slice(0...board.length - 1).join(", ") + " or #{board.last}"
        else
          board.first.to_s
        end
end
# rubocop:enable Lint/UselessAssignment

def player_places_piece!(board, current_player)
  if current_player == 'player'
    square = ""
    loop do
      prompt "Choose a square: (#{joinor(empty_squares(board))})"
      square = gets.chomp.to_i
      break if empty_squares(board).include?(square)
      prompt "Sorry, invalid choice."
    end
    board[square] = PLAYER_MARKER
  else
    computer_places_piece!(board)
  end
end

def alternate_player(player)
  case player
  when 'player' then player.clear << 'computer'
  else player.clear << 'player'
  end
end

def find_immediate_threat(board)
  threats = []
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(PLAYER_MARKER) == 2
      line.each { |square| threats << square if board[square] == INITIAL_MARKER }
    end
  end
  threats
end

def find_opportunity(board)
  opportunities = []
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(COMPUTER_MARKER) == 2
      line.each { |square| opportunities << square if board[square] == INITIAL_MARKER }
    end
  end
  opportunities
end

def computer_places_piece!(board)
  threats = find_immediate_threat(board)
  opportunities = find_opportunity(board)

  square = if !opportunities.empty?
             opportunities.sample
           elsif !threats.empty?
             threats.sample
           elsif board[5] == INITIAL_MARKER
             5
           else
             empty_squares(board).sample
           end

  board[square] = COMPUTER_MARKER
end

def board_full?(board)
  empty_squares(board).empty?
end

def winner?(board)
  !!detect_winner(board)
end

# rubocop:disable Style/ParenthesesAroundCondition
def detect_winner(board)
  WINNING_LINES.each do |line|
    # assignment in conditional is intentional in following lines
    if (winner = line.all? { |e| board[e] == PLAYER_MARKER })
      return "Player" if winner
    elsif (winner = line.all? { |e| board[e] == COMPUTER_MARKER })
      return "Computer" if winner
    end
  end
  nil
end
# rubocop:enable Style/ParenthesesAroundCondition

def display_score(player, computer)
  print(player < 5 && computer < 5 ? "=> Current score: " : "=> Final Score: ")
  puts "You => #{player} : Computer => #{computer}"
end

def play_again?(player_score, computer_score)
  answer = ''
  loop do
    if player_score < 5 && computer_score < 5
      prompt "Play next round? (Y/N)"
    else
      prompt "Play again? (Y/N)"
    end
    answer = gets.chomp
    if answer.downcase == 'y' || answer.downcase == 'n'
      break
    else
      prompt "Invalid choice. Only y or n accepted."
    end
  end
  answer.downcase == 'y'
end

player_score = 0
computer_score = 0

loop do
  board = initialize_board
  current_player = choose

  loop do
    display_board(board)
    display_score(player_score, computer_score)
    puts ""

    player_places_piece!(board, current_player)
    alternate_player(current_player)
    break if winner?(board) || board_full?(board)
  end

  display_board(board)
  if winner?(board)
    case detect_winner(board)
    when 'Player' then player_score += 1
    when 'Computer' then computer_score += 1
    end

    if player_score < 5 && computer_score < 5
      prompt "#{detect_winner(board)} wins round!"
    else
      prompt "#{detect_winner(board)} wins everything!"
    end

  else
    prompt "It's a tie!"
  end

  display_score(player_score, computer_score)

  if play_again?(player_score, computer_score)
    if player_score == 5 || computer_score == 5
      player_score = 0
      computer_score = 0
    end
  else
    prompt "Thanks for playing!"
    break
  end
end
