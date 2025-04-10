class UsersController <ApplicationController
  before_action :get_user, only:[:show, :liked, :feed, :discover, :followers, :following]
  
    def show
      @own_photos = @user.own_photos
    end
  
    def liked
      @liked_photos = @user.liked_photos
    end
  
    def feed
      @feed = @user.feed
    end
  
    def discover
      @discover = @user.discover
    end
  
    def followers
      @followers = @user.followers
    end
  
    def following
      @following = @user.leaders
    end
  
    private
  
    def get_user
      @user = User.find_by!(username: params.fetch("username"))
    end
  end
  