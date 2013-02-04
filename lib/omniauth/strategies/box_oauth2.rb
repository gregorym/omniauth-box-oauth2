require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class BoxOAuth2 < OmniAuth::Strategies::OAuth2
      option :name, 'box_oauth2'
      option :client_options, {
        :site => 'https://api.box.com/2.0',
        :authorize_url => 'https://api.box.com/oauth2/authorize',
        :token_method => :post,
        :token_url => 'https://api.box.com/oauth2/token',
        :param_name => 'code'
      }

      def callback_url
        super.sub('http:', 'https:')
      end

      def request_phase
        super
      end

      uid { raw_info['id'].to_s }

      info do
        {
          'username' => raw_info['login'],
          'name' => raw_info['name'],
          'email' => raw_info['login'],
          'image' => raw_info['avatar_url']
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        @raw_info ||= access_token.get('users/me').parsed
      end

    end
  end
end

OmniAuth.config.add_camelization 'box_oauth2', 'BoxOAuth2'
