
App.PostEntryComponent = Ember.Component.extend({
  post: null,
  viewingUser: null,

  actions: {
    changeVote: function() {
      if (this.get("post.hasVoted")) {
        this.get("post").downVote(this.get("store"), this.get("viewingUser"));
      } else {
        this.get("post").upVote(this.get("store"), this.get("viewingUser"));
      }
    }
  }
});
