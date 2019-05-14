require 'yaml'
MESSAGES = YAML.load_file('loan_calculator_messages.yml')

def prompt(msg)
  puts("=> #{msg}")
end

def valid_num?(number)
  return false if number.empty? || number.to_i < 0
  if number.to_i.to_s == number
    true
  else number.to_f.to_s == number
  end
end

prompt(MESSAGES['welcome'])
prompt(MESSAGES['uses'])

loop do
  loan_ammount = ''
  loop do
    prompt(MESSAGES['loan_ammount'])
    print("$")
    loan_ammount = gets.chomp
    # remove commas if user inputs a number in the format 1,000
    loan_ammount = loan_ammount.split(",").join if loan_ammount.include?(",")
    break if valid_num?(loan_ammount)
    prompt(MESSAGES["invalid"])
  end

  apr = ''
  loop do
    prompt(MESSAGES['apr'])
    apr = gets.chomp
    break if valid_num?(apr)
    prompt(MESSAGES['invalid'])
  end

  loan_duration = ''
  loop do
    prompt(MESSAGES['loan_duration'])
    loan_duration = gets.chomp
    break if valid_num?(loan_duration)
    prompt(MESSAGES['invalid'])
  end

  monthly_interest_rate = (apr.to_f / 100) / 12
  duration_to_months = (loan_duration.to_f * 12).to_i
  monthly_payment = loan_ammount.to_f * (monthly_interest_rate / (1 - (1 + monthly_interest_rate)**(-duration_to_months)))

  info = {
    'loan ammount' => '$' + loan_ammount.to_s,
    'APR' => apr.to_s + '%',
    'loan duration' => loan_duration.to_s + ' years',
  }

  prompt(MESSAGES['summary'])
  puts(MESSAGES['divider'])
  info.each { |key,value| puts(key.ljust(15) + "#{value}") }
  puts(MESSAGES['divider'])

  prompt("Your monthly payment is $%.2f for #{duration_to_months} months with a monthly interest rate of %.4f%" % [monthly_payment, (monthly_interest_rate * 100)])
  prompt(MESSAGES['again'])
  response = gets.chomp.downcase
  if response != 'y'
    prompt(MESSAGES['goodbye'])
    break
  end
end
