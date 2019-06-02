# Pick out the minimum age from our current Munster family hash:
ages = {
  'Herman' => 32,
  'Lily' => 30,
  'Grandpa' => 5843,
  'Eddie' => 10,
  'Marilyn' => 22,
  'Spot' => 237
}

min_age = 0

ages.each_with_index do |pair, index|
  min_age = pair[1] if index.zero?
  min_age = pair[1] if pair[1] < min_age
end

# more elegant solution provided by launchschool : ages.values.min

p min_age
