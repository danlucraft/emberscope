
App.LoginDialogController = Ember.ObjectController.extend({
  error: false,
  needs: "application",

  actions: {
    submit: function() {
      var model      = this.get("model");
      var identifier = model.get("identifier");
      var password   = model.get("password");
      $.post("http://localhost:8080/tokens", { identifier: identifier, password: password}).then(function(data) {
        var token = data.token;
        var app = this.get("controllers.application");
        app.loginWithToken(token);
        this.send("close");
      }.bind(this), function(data) {
        this.set("error", true);
      }.bind(this));

    },

    close: function() {
      this.set("error", false);
      return this.send('closeLoginModal');
    }
  }
});
