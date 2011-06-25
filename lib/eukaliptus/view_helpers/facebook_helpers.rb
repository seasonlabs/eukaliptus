module Eukaliptus
  module FacebookHelpers
    #Deprecated
    def fb_login(perms = %w{email publish_stream})
      raise 'fb_login is a deprecated method. Please use use fb_init instead.'
    end
    
    # Renders the HTML + JS that enables the app to log in to Facebook using
    # the Javascript method.
    #
    # Accepts the permissions that your application needs to work.
    # Use the second parameter to inject some JS that will be executed in fbAsyncInit.
    #
    # Use it one time in your layout header or use it in several app places
    # to ask the user for different permissions depending on the context, page, etc.
    def fb_init(perms = %w{email publish_stream}, append_to_init = "")
      js = <<-DATA
<div id="fb-root"></div>
<script type="text/javascript">
    window.fbAsyncInit = function() {
      FB.init({
          appId: '#{Facebook::APP_ID.to_s}',
          status: true,
          cookie: true,
          xfbml: true
      });

      FB.Canvas.setAutoResize(100);
      
      #{append_to_init}
    };

    (function() {
      var e = document.createElement('script'); e.async = true;
      e.src = document.location.protocol +
      '//connect.facebook.net/es_ES/all.js';
      document.getElementById('fb-root').appendChild(e);
    }());

    var login = function(targetUrl, perms) {
      if (perms == null) {
        perms = "#{perms.join(',')}"
      }
      FB.login(function(response) {
        if (response.session) {
            fixSession(JSON.stringify(response.session), targetUrl);
        } else {
            //pending to do when not logged in
        }
      }, {perms: perms});
    }

    var fixSession = function(fbSession, targetUrl) {
      $("body").prepend('<form id="fixSession"></form>');

      var f = $('form')[0];
      f.method = 'POST';
      f.action = "/cookie_fix";
          var m = document.createElement('input');
          m.setAttribute('type', 'hidden');
          m.setAttribute('name', '_session_id');
          m.setAttribute('value', fbSession);
          f.appendChild(m);

          m = document.createElement('input');
          m.setAttribute('type', 'hidden');
          m.setAttribute('name', 'redirect_to');
          m.setAttribute('value', targetUrl);
          f.appendChild(m);

      f.submit();
    }
</script>
      DATA
      
      js.html_safe
    end
    
    def on_fb_init(&block)
      <<-DATA
        <script>
          (function() {
            var oldFBInit = window.fbAsyncInit,
            var fn = function() {
              if (typeof(oldFBInit) === "function") {
                oldFBInit();
              }
              #{yield}
            }
            
            FB ? fn() : (window.fbAsyncInit = fn);
          }())
        </script>      
      DATA
    end

    # Function to create a new FB.ui dialog link
    def fb_ui(name, options ={})
      callback = options.delete(:callback)
      callback.gsub!('"', "'")

      data = "FB.ui(#{options.to_json.gsub('"', "'")}, #{callback});"
      link_to(name, '#', :onclick => data.html_safe)
    end
    
    # Create a new wall post
    # You can use it directly in your templates or call it from inside your helpers:
    #
    # module MyHelper
    #   def post_something_to_wall(something)
    #     fb_post_to_wall('Publish this great thing to wall!', :name => Something.name)
    #   end
    # end
    #
    # The options are the same than in Facebook feed post passed as Hash
    # see: http://developers.facebook.com/docs/reference/javascript/FB.ui/
    #
    # :callback
    # JS callback function to do somethink with the data
    def fb_post_to_wall(name = 'Post to wall', options = {})
      options = {
        :method => 'feed',
        :callback => 'function(response) {}'
      }.merge(options)

      fb_ui name, options
    end

    # Options
    #
    # :id
    # Required. The ID or username of the target user to add as a friend.
    #
    # :callback
    # JS callback function to do somethink with the data
    def fb_add_friend(name = 'Add as a friend', options = {})
      options = {
        :method => 'friends',
        :callback => 'function(response) {}'
      }.merge(options)

      fb_ui name, options
    end

    # Options
    #
    # :message
    # The request the receiving user will see. It appears as a question posed by the sending user.
    # The maximum length is 255 characters.
    #
    # :to
    # A user ID or username. Must be a friend of the sender.
    # If this is specified, the user will not have a choice of recipients.
    # If this is omitted, the user will see a friend selector and will be able to select a maximum of 50 recipients.
    #
    # :data
    # Optional, additional data you may pass for tracking. This will be stored as part of the request objects created.
    #
    # :title
    # Optional, the title for the friend selector dialog. Maximum length is 50 characters.
    #
    # :callback
    # JS callback function to do somethink with the data
    def fb_app_request(name = 'Invite to use this application', options = {})
      options = {
        :method => 'apprequests',
        :message => 'Invite your friends to use your app!',
        :callback => 'function(response) {}'
      }.merge(options)

      fb_ui name, options
    end

    # Options
    #
    # :credits_purchase
    # Whether it is a Credits purchase dialog or not
    #
    # :order_info
    # The internal key of the item you are selling.
    # IT's required in case credits_purchase is false and should only be meaningful to you.
    #
    # :dev_purchase_params
    # More developer parameters. For details, read http://developers.facebook.com/docs/creditsapi/
    #
    # :callback
    # JS callback function to do somethink with the data
    def fb_pay(name = 'Buy credits', options = {})
      options = {
        :method => 'pay',
        :callback => 'function(response) {}'
      }.merge(options)

      fb_ui name, options
    end
  end
end