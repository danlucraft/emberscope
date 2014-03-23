
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
        Post.create(attributes)
      else
        status 409
      end
    end
  end
end
