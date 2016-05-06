class Search < ActiveRecord::Base
  geocoded_by :full_location
  after_validation :geocode
end
