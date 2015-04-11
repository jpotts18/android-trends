puts 'Loading Models...'

# Define your classes based on the database, as always
class Library < ActiveRecord::Base
	has_many :extractions
end

class Extraction < ActiveRecord::Base
	belongs_to :library
end