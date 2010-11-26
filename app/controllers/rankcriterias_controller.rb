class RankcriteriasController < ApplicationController
  # GET /rankcriterias
  # GET /rankcriterias.xml
  def rankedtickets

    @rankcriterias = Rankcriteria.find(:all)

    Ticket.count_by_sql("update tickets set rank=0")

    @rankcriterias.each do |rankcriteria|

      @tickets = Ticket.find(:all, :conditions => "title ~* '#{rankcriteria.phrase}' or description ~* '#{rankcriteria.phrase}'")

      @tickets.each do |tkt|

        if rankcriteria.priorityhigh

          tkt.rank += 1

        else

          tkt.rank -= 1

        end

        tkt.save

      end     

    end


    @tickets = Ticket.find(:all, :order => "rank desc")
    

  end


  def index
    @rankcriterias = Rankcriteria.all
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
        result["words"]["w"].each do |key|
          criteria = Rankcriteria.new
          criteria.phrase = key["$"].to_s
          if key["@r"].to_s.downcase == "ant"
            criteria.priorityhigh = ! @rankcriteria.priorityhigh?
          else
            criteria.priorityhigh =  @rankcriteria.priorityhigh?
          end
          criteria.save
        end

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
end
