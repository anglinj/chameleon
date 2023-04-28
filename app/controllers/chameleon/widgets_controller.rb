class Chameleon::WidgetsController < ApplicationController
  before_action :find_widget
  before_action :validate_key
  skip_before_action :verify_authenticity_token

  def show
    @data = @widget.data.call(@auth)
    render "#{@widget.type}.xml"
  end

  protected
    def find_widget
      @widget = Chameleon::Widget.find_by(id: params[:id].gsub(".xml", ""))
      raise "Invalid widget!" if @widget.nil?
    end

    def validate_key
      return if @widget.public
      if @widget.auth
        @auth = @widget.auth.call(self, request, params)
        raise "Invalid authentication!" if !@auth
      else
        raise "Invalid key!" if params[@widget.key_parameter] != @widget.key
      end
    end
end
