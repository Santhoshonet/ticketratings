operators = ['doesnt','doesn\'t','don\'t','dont','n\'t','not','do not','does not']

operators.each do |word|

  notoperator = Notoperator.new
  notoperator.operator = word
  notoperator.save

end


ignorephases = ['this','those','there','is','was','are','were','it','he','she']

ignorephases.each do |word|

  ignorephrase =  Ignorephrase.new
  ignorephrase.phrase = word
  ignorephrase.save
  
end


