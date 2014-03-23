
module Emberscope
  class App < Sinatra::Application

    get "/posts/:id" do
      if post = Post.where(uuid: params[:uuid]).first
        status 200
        content_type :json
        PostSerializer.new(post).to_json
      else
        status 404
      end
    end

    get "/posts" do
      if posts = Post.all
        status 200
        content_type :json
        ActiveModel::ArraySerializer.new(posts, root: "posts").to_json
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
        PostSerializer.new(Post.create(attributes)).to_json
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
      if users = User.all
        status 200
        content_type :json
        ActiveModel::ArraySerializer.new(users, root: "users").to_json
      else
        status 404
      end
    end

    post "/users" do
      request.body.rewind
      if data = request.body.read and data != ""
        params = JSON.parse(data)
      else
        params = {"user" => {}}
      end
      attributes = {
        uuid:     params["user"]["uuid"],
        username: params["user"]["username"],
        email:    params["user"]["email"],
      }
      user = User.new_with_password(attributes, params["user"]["password"])
      if user.save
        status 200
        UserSerializer.new(user).to_json
      else
        status 409
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

    post "/login" do
      username_or_email = params[:identifier]
      password          = params[:password]
      if user = User.find_by_username_or_email(username_or_email)
        if user.authenticate(password)
          status 200
          UserSerializer.new(user).to_json
        else
          status 404
        end
      else
        status 404
      end
    end

  end
end




