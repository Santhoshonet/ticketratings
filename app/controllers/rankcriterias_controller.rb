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
    respond_to do |format|
      if @rankcriteria.save
        format.html { redirect_to(@rankcriteria, :notice => 'Rankcriteria was successfully created.') }
        format.xml  { render :xml => @rankcriteria, :status => :created, :location => @rankcriteria }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rankcriteria.errors, :status => :unprocessable_entity }
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
