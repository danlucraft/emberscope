
App.HomeController = Ember.ArrayController.extend({
  actions: {
    upVote: function(postId) {
      this.store.find("post", postId).then(function(post) {
        if (post) {
          post.incrementProperty("count");
        }
      });
    }
  }
});
