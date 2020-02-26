require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
require "rubygems"
require "titlecase"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }

# enter your Dark Sky API key here
ForecastIO.api_key = "02474b061a5e865db7fa38366b664a31"
news_api_key = "a142b833d1de4e82b0186015643bcc76"

get "/" do
  view "ask"
end

get "/news" do
  results = Geocoder.search(params["location"])
  lat_lng = results.first.coordinates
  lat = lat_lng[0]
  lng = lat_lng[1]

  forecast = ForecastIO.forecast(lat,lng).to_hash
  @city = params["location"].titlecase
  @current_temp = forecast["currently"]["temperature"]
  @current_state = forecast["currently"]["summary"]
  @forecast_array = forecast["daily"]["data"]

  url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=#{news_api_key}"
  @top_news = HTTParty.get(url).parsed_response.to_hash
  view "news"
end
