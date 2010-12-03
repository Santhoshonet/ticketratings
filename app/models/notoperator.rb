class Notoperator < ActiveRecord::Base

  validates_uniqueness_of "operator"

end
