operators = ['doesnt','doesn\'t','don\'t','dont','n\'t','not','do not','does not']
operators.each do |word|
  notoperator = Notoperator.new
  notoperator.operator = word
  notoperator.save
end


ignorephases = ['this','those','there','is','was','are','were','it','he','she','who','when','what','where','who','how']
ignorephases.each do |word|
  ignorephrase =  Ignorephrase.new
  ignorephrase.phrase = word
  ignorephrase.save
end


alternatephrases = [['can\'t','cannot'],['n\'t',' not']]
alternatephrases.each do |alternatephrase|
  altphrase = Alternatephrase.new
  altphrase.word = alternatephrase[0]
  altphrase.equalto = alternatephrase[1]
  altphrase.save
end


