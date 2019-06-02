require 'pry'

def all_substrings(str)
  all_subs = []
  index = 0
  after_index = 1
  if (str.length > 1)
    loop do
      if after_index == str.length
        index += 1
        after_index = index + 1
      end
      all_subs << str.slice(index..after_index)
      after_index += 1
      break if index == str.length - 2
    end
  end
  all_subs
end

def find_palindrome(array)
  results = []
  array.each { |str| results << str if str.reverse == str  }
  results
end

p find_palindrome(all_substrings("halo"))
