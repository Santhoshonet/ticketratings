class Rankcriteria < ActiveRecord::Base

  validates_uniqueness_of :phrase
  #before_save changecase

  def changecase

    self.phrase = self.phrase.to_s.downcase

  end


end
