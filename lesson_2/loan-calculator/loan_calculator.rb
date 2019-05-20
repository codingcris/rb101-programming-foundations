require 'yaml'
MESSAGES = YAML.load_file('loan_calculator_messages.yml')

def prompt(msg)
  puts("=> #{msg}")
end

def retrieve_loan_amount
  loop do
    prompt(MESSAGES['loan_amount'])
    print('$')
    amount = gets.chomp
    # remove commas if user inputs a number in the format 1,000
    amount = amount.split(",").join if amount.include?(",")
    return amount if valid_num?(amount)
    prompt(MESSAGES["invalid"])
  end
end

def retrieve_apr
  loop do
    prompt(MESSAGES['apr'])
    apr = gets.chomp
    return apr if valid_num?(apr)
    prompt(MESSAGES['invalid'])
  end
end

def retrieve_duration
  loop do
    prompt(MESSAGES['loan_duration'])
    years = gets.chomp
    return years.to_i if valid_num?(years)
    prompt(MESSAGES['invalid'])
  end
end

def valid_num?(number)
  return false if number.empty? || number.to_f <= 0
  true if number.to_i.to_s == number || number.to_f.to_s == number
end

def payment_calc(loan_amount, monthly_rate, months)
  loan_amount.to_f * (monthly_rate / (1 - (1 + monthly_rate)**-months))
end

def show_summary(loan_amount, apr, months)
  info = {
    'loan amount' => '$' + loan_amount.to_s,
    'APR' => apr.to_s + '%',
    'loan duration' => months.to_s + ' months'
  }

  prompt(MESSAGES['summary'])
  puts(MESSAGES['divider'])
  info.each { |key, value| puts(key.ljust(15) + value.to_s) }
  puts(MESSAGES['divider'])
end

def show_payment(monthly_payment, months, monthly_rate)
  prompt(format("Your monthly payment is $%.2<payment>f for #{months} months \
with a monthly interest rate of %.4<rate>f%", payment: monthly_payment,
                                              rate: monthly_rate * 100))
end

def again?
  loop do
    prompt(MESSAGES['again'])
    response = gets.chomp.downcase
    if response == 'y'
      Gem.win_platform? ? (system "cls") : (system "clear")
    end
    return response if response == 'y' || response == 'n'
    prompt(MESSAGES['invalid_again'])
  end
end

prompt(MESSAGES['welcome'])
prompt(MESSAGES['uses'])

loop do
  loan_amount = retrieve_loan_amount
  apr = retrieve_apr
  years = retrieve_duration

  monthly_rate = (apr.to_f / 100) / 12
  months = (years.to_f * 12).to_i
  monthly_payment = payment_calc(loan_amount, monthly_rate, months)

  show_summary(loan_amount, apr, months)
  show_payment(monthly_payment, months, monthly_rate)

  response = again?
  unless response == 'y'
    prompt(MESSAGES['goodbye'])
    break
  end
end
