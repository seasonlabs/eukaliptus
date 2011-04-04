module Eukaliptus
  module FacebookHelper
    def facebook_js
      <<-ALGO
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

          var login = function(targetUrl) {
            FB.login(function(response) {
              if (response.session) {
                  fixSession(JSON.stringify(response.session), targetUrl);
              } else {
                  //pending to do when not logged in
              }
            }, {perms:'publish_stream'});
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
      ALGO
    end
  end
end