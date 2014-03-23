App.ApplicationController = Ember.Controller.extend({
  loggedInUser: null,

  loginWithToken: function(token) {
    this.store.find("user", {token: token}).then(function(user) {
      this.loginWithUserAndToken(user, token);
    }.bind(this));
  },

  loginWithUserAndToken: function(user, token) {
    this.set("loggedInUser", user);
  },
});
