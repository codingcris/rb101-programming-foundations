# Create a hash that expresses the frequency with which each letter occurs in this string:
statement = "The Flintstones Rock"
letter_frequency = Hash.new

statement.split.join.each_char do |char|
  if letter_frequency.key?(char)
    letter_frequency[char] += 1
  else
    letter_frequency[char] = 1
  end
end

puts letter_frequency
