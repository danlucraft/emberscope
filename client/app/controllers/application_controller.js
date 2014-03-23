App.ApplicationController = Ember.Controller.extend({
  loggedInUser: null,

  loginWithToken: function(token) {
    console.log(token)
    this.store.find("user", {token: token}).then(function(user) {
      console.log(user, user.get("username"));
      this.set("loggedInUser", user);
    }.bind(this));
  }
});
