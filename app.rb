require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require_relative 'cookbook'
require_relative 'recipe'
set :bind, '0.0.0.0'
# configure :development do
#   use BetterErrors::Middleware
#   BetterErrors.application_root = File.expand_path('..', __FILE__)
# end

csv_file = File.join(__dir__, 'lib/recipes.csv')
cookbook = Cookbook.new(csv_file)

get '/' do
  @cookbook = cookbook
  erb :index
end

get '/cookbook/:index_no' do
  @cookbook=cookbook
  recipe_index = params['index_no'].to_i
  @recipe = @cookbook.all[recipe_index]
  erb :show
end

post '/' do
  @cookbook = cookbook
  # pry
  name = params[:name]
  description = params[:description]
  new_recipe = Recipe.new(name, description)
  @cookbook.add_recipe(new_recipe)
  @cookbook.save_csv
  erb :index
end
