
module Emberscope
  class App < Sinatra::Application

    def current_user
      token = request.env["HTTP_X_AUTHENTICATION_TOKEN"]
      if token
        User.find_by_token(token)
      end
    end

    get "/posts/:uuid" do
      if post = Post.where(uuid: params[:uuid]).first
        status 200
        content_type :json
        PostSerializer.new(post, scope: current_user).to_json
      else
        status 404
      end
    end

    def add_pagination(data, collection)
      data["meta"] ||= {}
      data["meta"]["total"]   = collection.total_entries
      data["meta"]["page"]    = collection.current_page
      data["meta"]["perPage"] = collection.per_page
      data["meta"]["pages"]   = (collection.total_entries.to_f/collection.per_page).ceil
    end

    POSTS_PER_PAGE = 10

    get "/posts" do
      if params[:userId]
        if user = User.where(uuid: params[:userId]).first
          status 200
          content_type :json
          posts = user.posts.order(:created_at).paginate(page: (params[:page]||1).to_i, per_page: POSTS_PER_PAGE)
          j = ActiveModel::ArraySerializer.new(posts, root: "posts", scope: current_user).as_json
          add_pagination(j, posts)
          j.to_json
        else
          status 404
          nil
        end
      elsif posts = Post.all
        status 200
        content_type :json
        ActiveModel::ArraySerializer.new(posts, root: "posts", scope: current_user).to_json
      else
        status 404
        nil
      end
    end

    post "/posts" do
      if current_user
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
          post = current_user.posts.create(attributes)
          PostSerializer.new(post, scope: current_user).to_json
        else
          status 409
        end
      else
        status 403
        nil
      end
    end

    post "/posts/:post_uuid/vote" do |post_uuid|
      status 200
      if current_user and post = Post.where(uuid: post_uuid).first
        current_user.upvote(post)
      end
      nil
    end

    delete "/posts/:post_uuid/vote" do |post_uuid|
      status 200
      if current_user and post = Post.where(uuid: post_uuid).first
        current_user.downvote(post)
      end
      nil
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

  end
end




