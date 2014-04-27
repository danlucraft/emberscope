
App.Router.map(function() {
  this.route("home", { path: "/" });
  this.resource("post", { path: "/posts/:post_id" }, function() {
  });
});

App.MissingRoute = Em.Route.extend({
  redirect: function() {
    this.transitionTo('home');
  }
});
