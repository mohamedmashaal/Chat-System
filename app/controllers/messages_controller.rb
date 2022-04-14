class MessagesController < ApplicationController
  before_action :get_chat, only: [:index, :create]
  before_action :get_message, only: [:show, :update, :destroy]


  # GET /applications/:application_id/chats/:chat_id/messages(.:format)
  def index
    if params.has_key?(:search)
      if @error == 0
        render json: @error_message, status: @status_code
      elsif @error == 1
        render json: @error_message, status: @status_code
      elsif @error == 2
        render json: @error_message, status: @status_code
      else
        results = do_search
        render json: results, :except => [:id, :chat_id]
      end
    else
      if @error == 0
        render json: @error_message, status: @status_code
      elsif @error == 1
        render json: @error_message, status: @status_code
      elsif @error == 2
        render json: @error_message, status: @status_code
      else
        messages = @chat.messages.select(:number, :body).to_json(except: :id)
        render json: messages, status: :ok
      end
    end
  end

  # GET /applications/:application_id/chats/:chat_id/messages/1
  def show
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    elsif @error == 2
      render json: @error_message, status: @status_code
    elsif @error == 3
      render json: @error_message, status: @status_code
    else
      render json: {message_number: @message.number, message: @message.body}, status: :ok
    end
  end

  # POST /applications/:application_id/chats/:chat_id/messages
  def create
    if params[:body] == nil
      render json: {status: 'ERROR', message: 'No Message'}, status: :bad_request
      return
    end
    body = (params[:body] == nil) ? "" : params[:body]
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    elsif @error == 2
      render json: @error_message, status: @status_code
    else
      ActiveRecord::Base.transaction do
        @chat.lock!
        message = @chat.messages.new
        if @chat.messages_count == 0
          message.number = 1
        else
          message.number = @chat.messages.maximum(:number) + 1
        end
        message.body = body
        if message.save
          render json: message.number, status: :created
        else
          render json: { status: 'ERROR', message: "Couldn't Create Message" }, status: :internal_server_error
        end
      end
    end
  end

  # PATCH/PUT /applications/:application_id/chats/:chat_id/messages/1
  def update
    new_body = params[:body]
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    elsif @error == 2
      render json: @error_message, status: @status_code
    elsif @error == 3
      render json: @error_message, status: @status_code
    else
      if @message.update({body: new_body})
        render json: {status: 'SUCCESS', message: 'Message Updated'}, status: :ok
      else
        render json: {status: 'ERROR', message: "Couldn't Update Message"}, status: :internal_server_error
      end
    end
  end

  # DELETE /applications/:application_id/chats/:chat_id/messages/1
  def destroy
    if @error == 0
      render json: @error_message, status: @status_code
    elsif @error == 1
      render json: @error_message, status: @status_code
    elsif @error == 2
      render json: @error_message, status: @status_code
    elsif @error == 3
      render json: @error_message, status: @status_code
    else
      @message.destroy
      render json: {status: 'SUCCESS', message: 'Message Deleted'}, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_message
      token = params[:application_id]
      chat_number = params[:chat_id]
      message_number = params[:id]
      @error = -1
      if token == nil || chat_number == nil || message_number == nil
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
      chat = application.chats.find_by({number: chat_number})
      if chat == nil
        @error = 2
        fill_error
        return
      end
      @message = chat.messages.find_by({number: message_number})
      if @message == nil
        @error = 3
        fill_error
      end
    end

    def get_chat
      token = params[:application_id]
      chat_number = params[:chat_id]
      @error = -1
      if token == nil || chat_number == nil
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
      @chat = application.chats.find_by({number: chat_number})
      if @chat == nil
        @error = 2
        fill_error
      end
    end

    # Only allow a trusted parameter "white list" through.
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
      if @error == 3
        @error_message = {status: 'ERROR', message: 'No Such Message'}
      end
      @status_code =:bad_request
    end


    def do_search
      response = Message.__elasticsearch__.search(
        query: {
          bool: {
            filter: {
              term: {
                chat_id: @chat.id
              }
            },
            must: {
              query_string: {
                query: "*#{params[:search]}*",
                default_field: "body"
              }
            }
          }
        }
      ).results
      result = []
      response.results.each do |x|
        result.push(x['_source'])
      end
      return result
    end
end
