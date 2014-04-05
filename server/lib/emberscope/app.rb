
module Emberscope
  class App < Sinatra::Application

    def current_user
      token = request.env["HTTP_X_AUTHENTICATION_TOKEN"]
      if token
        User.find_by_token(token)
      end
    end

    get "/posts/:id" do
      if post = Post.where(uuid: params[:uuid]).first
        status 200
        content_type :json
        PostSerializer.new(post, scope: current_user).to_json
      else
        status 404
      end
    end

    get "/posts" do
      if posts = Post.all
        status 200
        content_type :json
        ActiveModel::ArraySerializer.new(posts, root: "posts", scope: current_user).to_json
      else
        status 404
      end
    end

    post "/posts" do
      request.body.rewind
      data = JSON.parse request.body.read
      attributes = {
        title:    data["post"]["title"],
        url:      data["post"]["url"],
      }
      if attributes.values.all?
        attributes[:text] = data["text"]
        status 200
        content_type :json
        PostSerializer.new(Post.create(attributes), scope: current_user).to_json
      else
        status 409
      end
    end

    get "/users/:id" do
      if user = User.where(uuid: params[:id]).first
        status 200
        content_type :json
        UserSerializer.new(user).to_json
      else
        status 404
      end
    end

    get "/users" do
      if token = params[:token]
        if user = User.find_by_token(token)
          status 200
          content_type :json
          ActiveModel::ArraySerializer.new([user], root: "users").to_json
        else
          status 404
        end
      else
        if users = User.all
          status 200
          content_type :json
          ActiveModel::ArraySerializer.new(users, root: "users").to_json
        else
          status 404
        end
      end
    end

    post "/users" do
      request.body.rewind
      if data = request.body.read and data != ""
        params = JSON.parse(data)
      else
        params = {"user" => {}}
      end
      params["user"] ||= {}
      attributes = {
        uuid:     params["user"]["uuid"],
        username: params["user"]["username"],
        email:    params["user"]["email"],
      }
      user = User.new_with_password(attributes, params["user"]["password"])
      if user.save
        status 200
        content_type :json
        hash = UserSerializer.new(user).as_json
        hash["token"] = user.new_token
        hash.to_json
      else
        status 409
        content_type :json
        user.errors.to_json
      end
    end

    delete "/users/:id" do
      if user = User.where(uuid: params[:id]).first
        user.destroy
        status 200
      else
        status 404
      end
    end

    post "/tokens" do
      sleep 1
      username_or_email = params[:identifier]
      password          = params[:password]
      if user = User.find_by_username_or_email(username_or_email)
        if user.authenticate_password(password)
          status 200
          content_type :json
          {token: user.new_token}.to_json
        else
          status 404
        end
      else
        status 404
      end
    end

    post "/votes" do
      user_uuid = params["user"]
      post_uuid = params["post"]
      Vote.for(post_uuid, user_uuid)
    end

    delete "/votes/:id" do |id|
      if vote = Vote.find_by_client_side_id(id)
        vote.destroy
      end
    end

  end
end




