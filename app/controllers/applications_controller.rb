class ApplicationsController < ApplicationController
  before_action :get_application, only: [:show, :update, :destroy]

  # GET /applications
  def index
    applications = Application.select(:name).to_json(except: :id)
    render json: applications, status: :ok
  end

  # GET /applications/1
  def show
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    else
      render json: {name: @application.name, chats_count: @application.chats_count}, status: :ok
    end
  end

  # POST /applications
  def create
    name = params[:name]
    if name == nil
      render json: {status: 'ERROR', message: 'No Name'}, status: :bad_request
      return
    end
    application = Application.new
    application.name = name
    application.chats_count = 0

    if application.save
      render json: application.token, status: :created
    else
      render json: {status: 'ERROR', message: "Couldn't Create Application"}, status: :internal_server_error
    end
  end

  # PATCH/PUT /applications/1
  def update
    new_name = params[:name]
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    else
      if @application.update({name: new_name})
        render json: {status: 'SUCCESS', message: 'Application Updated'}, status: :ok
      else
        render json: {status: 'ERROR', message: "Couldn't Update Application"}, status: :internal_server_error
      end
    end
  end

  # DELETE /applications/1
  def destroy
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    else
      @application.destroy
      render json: {status: 'SUCCESS', message: 'Application Deleted'}, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_application
      token = params[:id]
      @error = -1
      if token == nil
        @error = 0
        fill_error
        return
      end
      @application = Application.find_by(token: token)
      if @application == nil
        @error = 1
        fill_error
      end
    end

    def fill_error
      if @error == 0
        @error_message = {status: 'ERROR', message: 'Missing Parameters'}
      end
      if @error == 1
        @error_message = {status: 'ERROR', message: 'No Such Application'}
      end
      @status_code =:bad_request
    end

end
