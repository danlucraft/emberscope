App.UserController = Ember.Controller.extend({
  page: 1,

  posts: function() {
    return this.store.find("post", { userId: this.get("model.id"), page: this.get("page") });
  }.property("model", "page"),

  showPrevPageLink: function() {
    return this.get("page") > 1;
  }.property("page"),

  showNextPageLink: function() {
    return this.get("page") < this.get("posts.content.meta.pages");
  }.property("page", "posts.content.meta.pages"),

  actions: {
    nextPage: function() {
      this.set("page", this.get("page") + 1);
    },

    prevPage: function() {
      this.set("page", Math.max(this.get("page") - 1, 1));
    }
  }

});
