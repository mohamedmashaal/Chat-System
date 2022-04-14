class ChatsController < ApplicationController
  before_action :get_chat, only: [:show, :destroy]
  before_action :get_application, only:[:index, :create]

  # GET /applications/:application_id/chats
  def index
    if @error == 0
      chats = @application.chats.select(:number, :messages_count).to_json(except: :id)
      render json: chats, status: :ok
    end
  end

  # GET /applications/:application_id/chats/1
  def show
    if @error == 0
      render json: {chat: @chat.number, messages_count: @chat.messages_count}, status: :ok
    end
  end

  # POST /applications/:application_id/chats
  def create
    if @error == 0
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
      @chat.destroy
      render json: {status: 'SUCCESS', message: 'Chat Deleted'}, status: :ok
    end
  end

  private
    def get_chat
      token = params[:application_id]
      chat_id = params[:id]
      @error = 0
      if token == nil || chat_id == nil
        @error = 1
        render json: {status: 'ERROR', message: 'Missing Parameters'}, status: :bad_request
        return
      end
      application = Application.find_by({token: token})
      if application == nil
        @error = 1
        render json: {status: 'ERROR', message: 'No Such Application'}, status: :bad_request
        return
      end
      @chat = Chat.find_by({application_id: application.id, number: chat_id})
      if @chat == nil
        @error = 1
        render json: {status: 'ERROR', message: 'No Such Chat'}, status: :bad_request
      end
    end

    def get_application
      token = params[:application_id]
      @error = 0
      if token == nil
        @error = 1
        render json: {status: 'ERROR', message: 'Missing Parameters'}, status: :bad_request
        return
      end
      @application = Application.find_by({token: token})
      if @application == nil
        @error = 1
        render json: {status: 'ERROR', message: 'No Such Application'}, status: :bad_request
      end
    end


end
