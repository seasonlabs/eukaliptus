namespace :facebook do

  desc "List fake users"
  task :list_fake_users => :environment do
    puts connect_to_facebook.list
  end

  desc "Create fake user"
  task :create_fake_user => :environment do
    connect_to_facebook.create(true, 'publish_stream')
  end

end

def connect_to_facebook
  oauth = Koala::Facebook::OAuth.new
  options = { :app_access_token => oauth.get_app_access_token, :app_id => Facebook::APP_ID}
  Koala::Facebook::TestUsers.new(options)
end
