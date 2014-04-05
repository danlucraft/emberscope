
App.HomeController = Ember.ArrayController.extend({
  needs: "application",
  loggedInUser: Ember.computed.alias("controllers.application.loggedInUser"),

});
