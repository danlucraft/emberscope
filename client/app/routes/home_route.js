App.HomeRoute = Ember.Route.extend({
  model: function() {
    return this.store.find("post");
  }
});
