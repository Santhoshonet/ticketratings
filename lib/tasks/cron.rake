task :cron => :environment do

  # cron job started here

  rankcontroller = RankcriteriasController.new

  rankcontroller.processrankcriteriadictionery()
  


end