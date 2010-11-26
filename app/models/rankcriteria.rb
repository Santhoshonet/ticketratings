class Rankcriteria < ActiveRecord::Base

  validates_uniqueness_of :phrase

end
