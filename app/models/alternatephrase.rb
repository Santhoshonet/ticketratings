class Alternatephrase < ActiveRecord::Base

   validates_uniqueness_of "word"

end
