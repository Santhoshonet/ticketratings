class Ignorephrase < ActiveRecord::Base

  validates_uniqueness_of "phrase"

end
