
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
      url:     "http://localhost:8080/posts/" + post.get("id") + "/vote",
      headers: { "X-AUTHENTICATION-TOKEN": localStorage.token },
      type:    "POST",
    }).done(function() {
      console.log("voted");
    });
  },

  unvote: function(user, post) {
    $.ajax({
      url:     "http://localhost:8080/posts/" + post.get("id") + "/vote",
      headers: { "X-AUTHENTICATION-TOKEN": localStorage.token },
      type:    "DELETE"
    }).done(function() {
      console.log("unvoted");
    });

  },
});
