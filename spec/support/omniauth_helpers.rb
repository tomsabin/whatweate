# rubocop:disable all

module OmniauthHelpers
  def setup_omniauth
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = nil
    OmniAuth.config.mock_auth[:twitter] = nil
  end

  def setup_valid_facebook_callback
    OmniAuth.config.mock_auth[:facebook] = facebook_auth_hash
  end

  def setup_invalid_facebook_callback
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end

  def setup_valid_twitter_callback
    OmniAuth.config.mock_auth[:twitter] = twitter_auth_hash
  end

  def setup_invalid_twitter_callback
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end

  def facebook_auth_hash
    OmniAuth::AuthHash.new({
      provider: "facebook",
      uid: "123456",
      info: {
        email: "user@example.com",
        name: "Cookie Monster",
        first_name: "Cookie",
        last_name: "Monster",
        image: "http://graph.facebook.com/123456/picture",
        urls: {
          "Facebook" => "https://www.facebook.com/app_scoped_user_id/123456/"
        },
        verified: true
      },
      credentials: {
        token: "AUTHTOKEN",
        expires_at: 1.week.from_now,
        expires: true
      },
      extra: {
        raw_info: {
          id: "123456",
          email: "user@example.com",
          first_name: "Cookie",
          gender: "male",
          last_name: "Monster",
          link: "https://www.facebook.com/app_scoped_user_id/123456/",
          locale: "en_GB",
          name: "Cookie Monster",
          timezone: 0,
          updated_time: 1.week.ago,
          verified: true
        }
      }
    })
  end

  def twitter_auth_hash
    OmniAuth::AuthHash.new({
      provider: "twitter",
      uid: "123456",
      info: {
        nickname: "cookiemonster",
        name: "Cookie Monster",
        location: "",
        image: "http://pbs.twimg.com/profile_images/123456/abcdef_normal.jpeg",
        description: "I like cookies",
        urls: {
          "Website" => "http://t.co/123456",
          "Twitter" => "https://twitter.com/cookiemonster"
        }
      },
      credentials: {
        token: "TOKEN",
        secret: "SECRET"
      },
      extra: {
        access_token: "ACCESSTOKEN",
        raw_info: {
          id: 123456,
          id_str: "123456",
          name: "Cookie Monster",
          screen_name: "cookiemonster",
          location: "",
          profile_location: nil,
          description: "I like cookies",
          url: "http://t.co/123456",
          entities: {
            url: {
              urls: [{
                url: "http://t.co/123456",
                expanded_url: "http://cookiemonster.com",
                display_url: "cookiemonster.co.uk",
                indices: [0, 22]
              }]
            },
            description: {
              urls: []
            }
          },
          protected: false,
          followers_count: 9001,
          friends_count: 1,
          listed_count: 10,
          created_at: 1.year.ago,
          favourites_count: 1234,
          utc_offset: 3600,
          time_zone: "London",
          geo_enabled: true,
          verified: false,
          statuses_count: 1,
          lang: "en",
          contributors_enabled: false,
          is_translator: false,
          is_translation_enabled: false,
          profile_background_color: "000000",
          profile_background_image_url: "http://pbs.twimg.com/profile_background_images/123456/abcdef.jpeg",
          profile_background_image_url_https: "https://pbs.twimg.com/profile_background_images/123456/abcdef.jpeg",
          profile_background_tile: false,
          profile_image_url: "http://pbs.twimg.com/profile_images/123456/abcdef.jpeg",
          profile_image_url_https: "https://pbs.twimg.com/profile_images/123456/abcdef.jpeg",
          profile_banner_url: "https://pbs.twimg.com/profile_banners/123456/abcdef",
          profile_link_color: "000000",
          profile_sidebar_border_color: "FFFFFF",
          profile_sidebar_fill_color: "FFFFFF",
          profile_text_color: "FFFFFF",
          profile_use_background_image: true,
          default_profile: false,
          default_profile_image: false,
          following: false,
          follow_request_sent: false,
          notifications: false
        }
      }
    })
  end
end
