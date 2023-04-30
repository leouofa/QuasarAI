module API
  module V1
    class TestController < ApplicationController
      api :GET, '/tests/', 'Test Endpoint.'
      description 'This endpoint is used to test API.'
      returns code: 200
      def index
        render json: { message: 'Hello World!' }
      end
    end
  end
end
