require 'kconv'

class SongsController < ApplicationController
  # GET /songs
  # GET /songs.xml
  def index
    @songs = Song.find(:all, :limit => 10, :order => 'id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/new
  # GET /songs/new.xml
  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(params[:id])
  end

  # POST /songs
  # POST /songs.xml
  def create
    if params[:song]["text"] == ''
      flash[:notice] = '歌詞を入力してください'
      redirect_to :action => "new"
      return
    end
    params[:song]["text"] = Kconv.kconv(params[:song]["text"], Kconv::UTF8)
    params[:song]["comment"] = Kconv.kconv(params[:song]["comment"], Kconv::UTF8)
    params[:song]["composition"] = nil
    params[:song]["remoteip"] = request.remote_ip
    params[:song]["useragent"] = request.user_agent
    @song = Song.new(params[:song])
    respond_to do |format|
      if @song.save
        Delayed::Job.enqueue @song
        format.html { redirect_to(@song) }
        format.xml  { render :xml => @song, :status => :created, :location => @song }
      else
        flash[:notice] = '作曲またはツイートに失敗しました'
        format.html { render :action => "new" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /songs/1
  # PUT /songs/1.xml
  def update
    @song = Song.find(params[:id])

    respond_to do |format|
      if @song.update_attributes(params[:song])
        flash[:notice] = 'Song was successfully updated.'
        format.html { redirect_to(@song) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.xml
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to(songs_url) }
      format.xml  { head :ok }
    end
  end
end
