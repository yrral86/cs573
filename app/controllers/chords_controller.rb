class ChordsController < ApplicationController
  # GET /chords
  # GET /chords.json
  def index
    @chords = Chord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chords }
    end
  end

  # GET /chords/1
  # GET /chords/1.json
  def show
    @chord = Chord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chord }
    end
  end

  # GET /chords/new
  # GET /chords/new.json
  def new
    @chord = Chord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chord }
    end
  end

  # GET /chords/1/edit
  def edit
    @chord = Chord.find(params[:id])
  end

  # POST /chords
  # POST /chords.json
  def create
    @chord = Chord.new(params[:chord])

    respond_to do |format|
      if @chord.save
        format.html { redirect_to @chord, notice: 'Chord was successfully created.' }
        format.json { render json: @chord, status: :created, location: @chord }
      else
        format.html { render action: "new" }
        format.json { render json: @chord.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chords/1
  # PUT /chords/1.json
  def update
    @chord = Chord.find(params[:id])

    respond_to do |format|
      if @chord.update_attributes(params[:chord])
        format.html { redirect_to @chord, notice: 'Chord was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @chord.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chords/1
  # DELETE /chords/1.json
  def destroy
    @chord = Chord.find(params[:id])
    @chord.destroy

    respond_to do |format|
      format.html { redirect_to chords_url }
      format.json { head :no_content }
    end
  end
end
