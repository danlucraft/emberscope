App.ApplicationController = Ember.Controller.extend({
  loggedInUser: null,

  loginWithToken: function(token) {
    this.store.find("user", {token: token}).then(function(users) {
      this.loginWithUserAndToken(users.objectAt(0), token);
    }.bind(this));
  },

  loginWithUserAndToken: function(user, token) {
    this.set("loggedInUser", user);
    localStorage.token = token;
  },

  logout: function() {
    delete localStorage.token;
    this.set("loggedInUser", null);
  },

  actions: {
    logout: function() {
      this.logout();
    }
  },
});
