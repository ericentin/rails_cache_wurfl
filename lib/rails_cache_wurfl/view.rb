module RailsCacheWurfl
  module View
    def output_phone
      RailsCacheWurfl.get_phone(session[:phone_agent])
    end
  end
end