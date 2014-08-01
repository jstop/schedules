class RoutinesController < ApplicationController
  before_action :set_routine, only: [:show, :edit, :update, :destroy]

  # GET /routines
  # GET /routines.json
  def index
    @routines = Routine.all
    @default_start = DateTime.now.tomorrow.noon.strftime("%m/%d/%Y %I:%M %p")
  end

  # GET /routines/1
  # GET /routines/1.json
  def show
    puts params
    respond_to do |format|
      format.html
      format.ics { send_data(create_ical_from(@routine, params[:datetime], params[:days]), :filename=>"RoutineBuilders.ics", :disposition=>"inline; filename=RoutineBuilders.ics", :type=>'text/calendar')}
    end
  end

  # GET /routines/new
  def new
    @routine = Routine.new
  end

  # GET /routines/1/edit
  def edit
  end

  # POST /routines
  # POST /routines.json
  def create
    puts '=================================='
    puts '=================================='
    puts '=================================='
    puts routine_params
    @routine = Routine.new(routine_params)

    respond_to do |format|
      if @routine.save
        format.html { redirect_to @routine, notice: 'Routine was successfully created.' }
        format.json { render :show, status: :created, location: @routine }
      else
        format.html { render :new }
        format.json { render json: @routine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /routines/1
  # PATCH/PUT /routines/1.json
  def update
    respond_to do |format|
      if @routine.update(routine_params)
        format.html { redirect_to @routine, notice: 'Routine was successfully updated.' }
        format.json { render :show, status: :ok, location: @routine }
      else
        format.html { render :edit }
        format.json { render json: @routine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routines/1
  # DELETE /routines/1.json
  def destroy
    @routine.destroy
    respond_to do |format|
      format.html { redirect_to routines_url, notice: 'Routine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_routine
      @routine = Routine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def routine_params
      params.require(:routine).permit(:title, :purpose, :resources, :weeks, :days, :hours, :minutes, :user_id, :tag_list)
    end

    def create_ical_from(routine, start_date, days)
      #move this into a function or relocate
      #adjust_records(routine)
      start = DateTime.strptime(start_date, '%m/%d/%Y %I:%M %p')
      calendar = RiCal.Calendar do
        event do
          summary routine.title
          url routine.resources
          description routine.purpose + routine.resources
          dtstart     start.with_floating_timezone
          duration    "+PT#{routine.hours}H#{routine.minutes}M" #get_duration that will create the currect string for building the duration
          rrule       :freq => "WEEKLY", :until => start + routine.weeks.week, :byday => days
        end
      end
      calendar.export
    end
    def adjust_records(routine) if signed_in?  current_user.records << Record.new(routine_id: routine.id, start_date: params[:start_date])
        current_user.routines_used << routine.id
        current_user.save
        unless routine.used_by.include? current_user.id
          routine.used_by << current_user.id
          routine.inc(:download_count, 1)
          routine.save
        end
      end
    end
end
