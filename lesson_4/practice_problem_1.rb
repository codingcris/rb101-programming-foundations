#Turn this array into a hash where the names are the keys and the values are the positions in the array.
flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]
flintstones_hash = Hash.new

flintstones.each_with_index do |element, index|
  flintstones_hash[element] = index
end

p flintstones_hash
