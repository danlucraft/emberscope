
App.Router.map(function() {
  this.route("home", { path: "/" });
});

App.MissingRoute = Em.Route.extend({
  redirect: function() {
    this.transitionTo('home');
  }
});
