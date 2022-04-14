class ChatsController < ApplicationController
  before_action :get_chat, only: [:show, :destroy]
  before_action :get_application, only:[:index, :create]

  # GET /applications/:application_id/chats
  def index
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    else
    chats = @application.chats.select(:number, :messages_count).to_json(except: :id)
    render json: chats, status: :ok
    end
  end

  # GET /applications/:application_id/chats/1
  def show
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    elsif @error == 2
      render json: @error_message, status: @status_code
    else
      render json: {chat: @chat.number, messages_count: @chat.messages_count}, status: :ok
    end
  end

  # POST /applications/:application_id/chats
  def create
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    else
      ActiveRecord::Base.transaction do
        @application.lock!
        chat = @application.chats.new
        if @application.chats_count == 0
          chat.number = 1
        else
          chat.number = @application.chats.maximum(:number) + 1
        end
        chat.messages_count = 0
        if chat.save
          render json: chat.number, status: :created
        else
          render json: { status: 'ERROR', message: "Couldn't Create Chat" }, status: :internal_server_error
        end
      end
    end
  end

  # PATCH/PUT /applications/:application_id/chats/1
  def update

  end

  # DELETE /applications/:application_id/chats/1
  def destroy
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    elsif @error == 2
      render json: @error_message, status: @status_code
    else
      @chat.destroy
      render json: {status: 'SUCCESS', message: 'Chat Deleted'}, status: :ok
    end
  end

  private
    def get_chat
      token = params[:application_id]
      chat_id = params[:id]
      @error = -1
      if token == nil || chat_id == nil
        @error = 0
        fill_error
        return
      end
      application = Application.find_by({token: token})
      if application == nil
        @error = 1
        fill_error
        return
      end
      @chat = Chat.find_by({application_id: application.id, number: chat_id})
      if @chat == nil
        @error = 2
        fill_error
      end
    end

    def get_application
      token = params[:application_id]
      @error = -1
      if token == nil
        @error = 0
        fill_error
        return
      end
      @application = Application.find_by({token: token})
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
      if @error == 2
        @error_message = {status: 'ERROR', message: 'No Such Chat'}
      end
      @status_code =:bad_request
    end

end
