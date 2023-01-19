require "date"

p "Where are you located?"

user_location = gets.chomp

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("GMAPS_KEY")}"


require "open-uri"
raw_response_gmaps = URI.open(gmaps_url).read

p raw_response_gmaps.class

require "json"
parsed_gmaps = JSON.parse(raw_response_gmaps)

p parsed_gmaps.keys

results_array = parsed_gmaps.fetch("results")

only_result = results_array[0]

geo = only_result.fetch("geometry")

p geo

loc = geo.fetch("location")

lat = loc.fetch("lat")
long = loc.fetch("lng")

p lat
p long

darksky_url = "https://api.darksky.net/forecast/#{ENV.fetch("DARK_SKY_KEY")}/#{lat},#{long}"

p darksky_url

raw_response_darksky = URI.open(darksky_url).read

parsed_darksky = JSON.parse(raw_response_darksky)

hourly_hash = parsed_darksky.fetch("hourly")

hourly_array = hourly_hash.fetch("data")

p hourly_array[1]
# It's an array of hashes

p hourly_array[12].fetch("precipProbability")

p "It is currently #{hourly_array[0].fetch("temperature")}°F."

counter = 1
umbrella = false

while counter <= 12
  if hourly_array[counter].fetch("precipProbability") > 0.1
    p "In #{counter} hours, there is a #{hourly_array[counter].fetch("precipProbability") * 100} chance of precipitation."

    umbrella = true
  end
  
  counter = counter + 1
end

if umbrella == true
    p "You might want to take an umbrella!"
  else
    p "You probably won't need an umbrella today."
end 
  
