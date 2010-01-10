class HellosController < ApplicationController
  # GET /hellos
  # GET /hellos.xml
  def index
    @hellos = Hello.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hellos }
    end
  end

  # GET /hellos/1
  # GET /hellos/1.xml
  def show
    @hello = Hello.find(:first, params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hello }
    end
  end

  # GET /hellos/new
  # GET /hellos/new.xml
  def new
    @hello = Hello.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hello }
    end
  end

  # GET /hellos/1/edit
  def edit
    @hello = Hello.find(:first, params[:id])
  end

  # POST /hellos
  # POST /hellos.xml
  def create
    @hello = Hello.new(:first, params[:hello])

    respond_to do |format|
      if @hello.save
        flash[:notice] = 'Hello was successfully created.'
        format.html { redirect_to(@hello) }
        format.xml  { render :xml => @hello, :status => :created, :location => @hello }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hello.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hellos/1
  # PUT /hellos/1.xml
  def update
    @hello = Hello.find(:first, params[:id])

    respond_to do |format|
      if @hello.update_attributes(params[:hello])
        flash[:notice] = 'Hello was successfully updated.'
        format.html { redirect_to(@hello) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hello.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hellos/1
  # DELETE /hellos/1.xml
  def destroy
    @hello = Hello.find(:first, params[:id])
    @hello.destroy

    respond_to do |format|
      format.html { redirect_to(hellos_url) }
      format.xml  { head :ok }
    end
  end
end
