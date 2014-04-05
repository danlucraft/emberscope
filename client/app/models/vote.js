
App.Vote = DS.Model.extend({
  user: DS.belongsTo("user"),
  post: DS.belongsTo("post"),

  postId: function() {
    return this.get("post.id");
  }.property("post"),
});

App.Vote.reopenClass({
  vote: function(user, post) {
    $.ajax({
      url: "http://localhost:8080/votes",
      type: "POST",
      data: {post: post.get("id"), user: user.get("id")},
    }).done(function() {
      console.log("voted");
    });
  },

  unvote: function(user, post) {
    $.ajax({
      url: "http://localhost:8080/votes/" + post.get("id") + "-" + user.get("id"),
      type: "DELETE"
    }).done(function() {
      console.log("unvoted");
    });

  },
});
