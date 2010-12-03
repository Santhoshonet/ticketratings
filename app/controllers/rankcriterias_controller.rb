class RankcriteriasController < ApplicationController

  def showrankedtickets
    @tickets = Ticket.find(:all, :order => "rank desc")
  end

  def index
    @rankcriterias = Rankcriteria.find(:all, :order => "phrase")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rankcriterias }
    end
  end
  # GET /rankcriterias/1
  # GET /rankcriterias/1.xml
  def show
    @rankcriteria = Rankcriteria.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rankcriteria }
    end
  end
  # GET /rankcriterias/new
  # GET /rankcriterias/new.xml
  def new
    @rankcriteria = Rankcriteria.new
    @result = nil
    @wrongword = ''
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rankcriteria }
    end
  end
  # GET /rankcriterias/1/edit
  def edit
    @rankcriteria = Rankcriteria.find(params[:id])
  end
  # POST /rankcriterias
  # POST /rankcriterias.xml

  def create
    @rankcriteria = Rankcriteria.new(params[:rankcriteria])
    spellcheck = Spellcheck.new
    @wrongword = @rankcriteria.phrase
    if @rankcriteria.phrase.strip.split(' ').length < 2
      @result = spellcheck.check_word(@rankcriteria.phrase)
      unless @result["spellresult"]["c"].nil?
          #puts @result["spellresult"]["c"]["@l"] #length
          #puts @result["spellresult"]["c"]["$"]
          #@result["spellresult"]["c"]["$"] #strings
          #@result["spellresult"]["c"]["$"].to_s.split(/\t/)
        render :new
      else
        syn = Antonyms.new
        result = syn.get_antonyms(@rankcriteria.phrase)
        unless result["words"].nil?
          result["words"]["w"].each do |key|
            criteria = Rankcriteria.new
            criteria.phrase = key["$"].to_s.strip
            if key["@r"].to_s.downcase == "ant"
              criteria.priorityhigh = ! @rankcriteria.priorityhigh?
            else
              criteria.priorityhigh =  @rankcriteria.priorityhigh?
            end
            criteria.save
          end
        end
        @rankcriteria.isantonymprocessed=false
        if @rankcriteria.save
          redirect_to(@rankcriteria, :notice => 'Rankcriteria was successfully created.')
        else
          @result = nil
          redirect_to :action => "index"
        end
      end
    else
      @rankcriteria.phrase.split(' ').each do |word|
        @result = spellcheck.check_word(word)
        unless @result["spellresult"]["c"].nil?
          #@result["spellresult"]["c"]["$"].to_s.split(/\t/)
          @wrongword = word
          render :new
          return
        end
      end
      @rankcriteria.isantonymprocessed = false
      if @rankcriteria.save
        redirect_to(@rankcriteria, :notice => 'Rankcriteria was successfully created.')
      else
        @result = nil
        redirect_to :action => "index"
      end
    end
  end
  # PUT /rankcriterias/1
  # PUT /rankcriterias/1.xml
  def update
    @rankcriteria = Rankcriteria.find(params[:id])
    respond_to do |format|
      if @rankcriteria.update_attributes(params[:rankcriteria])
        format.html { redirect_to(@rankcriteria, :notice => 'Rankcriteria was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rankcriteria.errors, :status => :unprocessable_entity }
      end
    end
  end
  # DELETE /rankcriterias/1
  # DELETE /rankcriterias/1.xml
  def destroy
    @rankcriteria = Rankcriteria.find(params[:id])
    @rankcriteria.destroy
    respond_to do |format|
      format.html { redirect_to(rankcriterias_url) }
      format.xml  { head :ok }
    end
  end
  # GET /rankcriterias
  # GET /rankcriterias.xml
  def rankedtickets
    #@rankcriterias = Rankcriteria.find(:all)
    Ticket.count_by_sql("update tickets set rank=0")
=begin
    @rankcriterias.each do |rankcriteria|
      @tickets = Ticket.find(:all, :conditions => "title ~* '#{rankcriteria.phrase}' or description ~* '#{rankcriteria.phrase}'")
      @tickets.each do |tkt|
        puts  rankcriteria.phrase
        if rankcriteria.priorityhigh
          tkt.rank += 1
        else
          tkt.rank -= 1
        end
        tkt.save
      end
    end
=end
    @tickets = Ticket.find(:all)
    @notoperators = Notoperator.find(:all)
    @ignorewords = Ignorephrase.find(:all)

    @tickets.each do |tkt|
      #----------title checking------------
      title = tkt.title.to_s.strip.downcase
      unless matchword(title,tkt)
        processranks(title,tkt)
      end

      #---------Context Checking----------
      body = tkt.description.to_s.strip.downcase
      unless matchword(title,tkt)
        processranks(body,tkt)
      end
    end

    showrankedtickets()
    render :showrankedtickets
  end

  def processrankcriteriadictionery()

    rankcriterias = Rankcriteria.find(:all,:conditions => "isantonymprocessed = false")

    antonym = Antonyms.new

    @noofhitsperday = 0

    rankcriterias.each do |rankcrit|

        if scrappingantonyms(rankcrit.phrase,rankcrit.priorityhigh,antonym)

          rankcrit.isantonymprocessed=true
          rankcrit.save

        end
      
    end

  end

end


private

def processranks(title,tkt)

  if title.to_s.count('.') > 0
    # Checking all the combinations
    title.to_s.split('.').each do |txt|
        txt = txt.to_s.chomp('\n')
        if matchword(txt,tkt)
          next
        end
        if txt.to_s.count(',') > 0
          txt.to_s.split(",").each do |text|
            phrasematching(text,tkt)
          end
        else
          phrasematching(txt,tkt)
        end
    end
  else
    if title.to_s.count(',') > 0
      # Checking all the combinations
      title.to_s.split(',').each do |txt|
        phrasematching(txt,tkt)
      end
    else
      phrasematching(title,tkt)
    end
  end


  title.split(".").each do |txt|
    txt.to_s.split(',').each do |text|
        arrayofwords = []
        text.to_s.split(' ').each do |word|
          arrayofwords.push(word)
        end
        0.upto(arrayofwords.count()-1) do |frontindex1|
            isphrasefound = false
            (arrayofwords.count()-1).to_i.downto(0) do |noofwords|
              if noofwords - frontindex1 > 0
                word=''
                (frontindex1).to_i.upto(noofwords) do |frontindex2|
                    word += arrayofwords[frontindex2] + ' '
                end
                if word.strip != ''
                  if  matchword(word.strip,tkt)
                    isphrasefound = true
                    break
                  end
                end
              end
            end
            if isphrasefound
              break
            end
        end
=begin
        1.upto(arrayofwords.count()-2) do |frontindex|
          (arrayofwords.count()-1).to_i.downto(2) do |rearindex|
            word = ''
            if frontindex  < rearindex
              frontindex.upto(rearindex) do |idx|
                word += arrayofwords[idx] + ' '
              end
              if word.strip != ''
                matchword(word.strip,tkt)
              end
            end
            word = ''
            if frontindex  < rearindex
              (frontindex-1).to_i.upto(rearindex-1) do |idx|
                word += arrayofwords[idx] + ' '
              end
              if word.strip != ''
                matchword(word,tkt)
              end
            end
          end
        end
=end
      end
    end

 end

def phrasematching(text,tkt)
  
  isdontfollows = false
  ispositiverank = true
  
    #-------------- Phrase Matching Operation Starts here-----------------

    #-------------- Ignoring unnecessary words, Starts here-----------------
    @ignorewords.each do |ignoreword|
      text = text.to_s.chomp(ignoreword.phrase)
    end

    if matchword(text,tkt)
       return
    end

    #-------------- Word Matching Operation Starts here-----------------
    text.to_s.split(" ").each do |word|
      #-----not operators-----
      notoperator = ''
      @notoperators.each do |operator|
        if word.to_s.strip.casecmp(operator.operator) == 0
          notoperator = operator.operator
          break
        end
      end
      if notoperator != ''
        isdontfollows = true
        next
      elsif isdontfollows == true
        ispositiverank = false
      else
        ispositiverank = true
      end
      #-----Word-----
      rankcriteria = Rankcriteria.find(:all, :conditions => "phrase = '#{word}'")
      if rankcriteria.count() > 0
        if (ispositiverank and rankcriteria[0].priorityhigh) or (not ispositiverank and not rankcriteria[0].priorityhigh)
          tkt.rank += 1
        elsif (not ispositiverank and rankcriteria[0].priorityhigh) or (ispositiverank and not rankcriteria[0].priorityhigh)
          #tkt.rank -= 1
        end
        tkt.save
      end
      isdontfollows = false
    end
end

def matchword(word,tkt)

  rankcriteria = Rankcriteria.find(:all, :conditions => "phrase = '#{word}'")
  if rankcriteria.count() > 0
    tkt.rank += 1
    tkt.save
    return true
  else
    return false
  end

end

def scrappingantonyms(word,ishigherpriority,antonym)

  if @noofhitsperday  < 9999

    begin

      result = antonym.get_antonyms(word)

      @noofhitsperday += 1

      unless result["words"].nil?

        result["words"]["w"].each do |key|

          criteria = Rankcriteria.new

          keyword = ''
          keyrelation = ''
          keywordtype = ''

          if key.class.to_s.downcase.strip == "hash"

            keyword = key["$"].to_s.strip
            keyrelation = key["@r"].to_s.downcase
            keywordtype = key["@p"].to_s.downcase

          else
          
            keyword = result["words"]["w"]["$"].to_s.strip
            keyrelation = result["words"]["w"]["@r"].to_s.strip
            keywordtype = result["words"]["w"]["@p"].to_s.strip

          end


          criteria.phrase = keyword

          if keyrelation == "ant"
              criteria.priorityhigh = !(ishigherpriority)
          else
              criteria.priorityhigh =  ishigherpriority
          end
        
          criteria.isantonymprocessed=false

          if keywordtype != "noun"

              if criteria.save

                if scrappingantonyms(keyword,ishigherpriority,antonym)

                  criteria.isantonymprocessed=true
                  criteria.save

                end

              end

          else

              scrappingantonyms(keyword,ishigherpriority,antonym)

            end

        end

      end

      return true

    rescue Exception => ex

      puts ex.message

      return false

    end

  else

      return false
    
  end

end
