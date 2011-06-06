module Eukaliptus
  module FacebookHelpers
    # Renders the HTML + JS that enables the app to log in to Facebook using
    # the Javascript method.
    #
    # Accepts the permissions that your application needs to work.
    #
    # Use it one time in your layout header or use it in several app places
    # to ask the user for different permissions depending on the context, page, etc.
    def facebook_js(perms = %w{email publish_stream})
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



  function fixSession(fbSession, targetUrl) {
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

    # Renders invite dialog request
    def invites_js(message='Invite your friends to use your app!')
      "FB.ui({ method: 'apprequests', message: '#{message}'});"
    end

    # Create a new wall post
    # You can use it directly in your templates or call it from inside your helpers:
    #
    # module MyHelper
    #   def post_something_to_wall(something)
    #     link_to_post_to_wall('Publish this great thing to wall!', :name => Something.name)
    #   end
    # end
    #
    # The options are the same than in Facebook feed post passed in a Hash
    # see: http://developers.facebook.com/docs/reference/javascript/FB.ui/
    def link_to_post_to_wall(name, options = {})
      options = {
        :method => 'feed',
        :callback => 'function(response) {}'
      }.merge(options)

      data= <<-DATA
FB.ui(
 {
   method: '#{options[:method]}',
   name: '#{options[:name]}',
   link: '#{options[:link]}',
   picture: '#{options[:picture]}',
   caption: '#{options[:caption]}',
   description: '#{options[:description]}'
 }, #{options[:callback]}
);
        DATA

        link_to(name, '#', :onclick => data.html_safe)
      end
  end
end