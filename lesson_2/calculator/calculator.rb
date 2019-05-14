# ask the user for two numbers
# ask the user for an operation
# perform the operation
# output the result
require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts ">> #{message}"
end

def num?(number)
  decimalSplit = number.split('.')
  return false if decimalSplit.size > 2
  decimalSplit.each {|num| return false if !valid_num?(num)}
  true
end

def valid_num?(number)
  return num?(number) if number.include?(".")
  number.to_i.to_s == number
end

prompt(MESSAGES['welcome'])

float = false

loop do
  number1 = ''
  loop do
    prompt(MESSAGES['first_number'])
    number1 = gets.chomp
    float = number1.include?(".") && num?(number1)
    break if valid_num?(number1)
    prompt(MESSAGES['valid_number'])
  end

  number2 = ''
  loop do
    prompt(MESSAGES['second_number'])
    number2 = gets.chomp
    float = number2.include?(".") && num?(number2) if !float
    break if valid_num?(number2)
    prompt(MESSAGES['valid_number'])
  end

  operator_prompt = <<~MSG
    Choose an operation:
        1) Addition
        2) Subtraction
        3) Multiplication
        4) Division
    MSG
  valid_operations = %w(1 2 3 4)

  operator = ""
  loop do
    prompt(operator_prompt)
    operator = gets.chomp
    break if valid_operations.include?(operator)
    prompt(MESSAGES['valid_operation'])
  end

  result =  case operator
            when '1' then if float
              number1.to_f + number2.to_f
              else number1.to_i + number2.to_i
              end
            when '2' then unless float
              number1.to_i - number2.to_i
              else number1.to_f - number2.to_f
              end
            when '3' then unless float
              number1.to_i * number2.to_i
            else number1.to_f * number2.to_f
            end
            when '4' then number1.to_f / number2.to_f
            end

  prompt("#{MESSAGES['result']}#{result}")

  prompt(MESSAGES['continue'])
  break unless gets.chomp.downcase == 'y'
end
