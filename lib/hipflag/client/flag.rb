module Hipflag
  class Client
    module Flag
      def flag(flag_id, user_id: nil)
        perform_request(:get, "flags/#{flag_id}?#{flag_params(user_id)}")
      end

      def update_flag(flag_id, params)
        perform_request(:put, "flags/#{flag_id}", data: { flag: params }.to_json)
      end

      private

      def flag_params(user_id)
        return if user_id.nil?

        URI.encode_www_form(user_id: user_id)
      end
    end
  end
end
