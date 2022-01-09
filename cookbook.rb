require 'csv'
require 'open-uri'
require 'nokogiri'
require_relative 'recipe'

class Cookbook
  # initialize(csv_file_path) which loads existing Recipe from the CSV
  def initialize(csv_file_path)
    @recipes = []
    CSV.foreach(csv_file_path) do |row|
      @recipes << Recipe.new(row[0], row[1])
    end
  end

  # all which returns all the recipes
  def all
    @recipes
  end

  # add_recipe(recipe) which adds a new recipe to the cookbook
  def add_recipe(recipe)
    @recipes << recipe
    # save_csv  -> added this to controller
  end

  # remove_recipe(recipe_index) which removes a recipe from the cookbook.
  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    # save_csv  -> added this to controller
  end

  def save_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    filepath    = 'lib/recipes.csv'

    CSV.open(filepath, 'wb', csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description]
      end
    end
  end

  def import_recipes(ingredient)
    url = "https://www.allrecipes.com/search/results/?search=#{ingredient}"
    # url = 'strawberry.html'

    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    n = 0
    imported_recipes = []
    html_doc.search('.card__detailsContainer-left').each do |element|
      n += 1
      break if n > 5
      name = element.search('.card__title').text.strip
      description = element.search('.card__summary').text.strip
      new_recipe = Recipe.new(name, description)
      imported_recipes << new_recipe
      # puts "#{n}. #{element.search('.card__title').text.strip}"
    end
    imported_recipes
  end
end

# puts element.text.strip
# puts element.attribute('href').value
