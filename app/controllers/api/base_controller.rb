class Api::BaseController < ApplicationController
  before_action :default_format_json

  private

  def default_format_json
    request.format = 'json'
  end
end
