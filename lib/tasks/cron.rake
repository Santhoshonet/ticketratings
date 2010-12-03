task :cron => :environment do

  # cron job started here
  rankcontroller = RankcriteriasController.new

  #processing ranking for each tickets
  rankcontroller.rankedtickets


  # processing rank dictionery
  rankcontroller.processrankcriteriadictionery()


end