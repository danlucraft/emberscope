
App.SignupDialogController = Ember.ObjectController.extend({
  needs: "application",
  errors: {},

  actions: {
    submit: function() {
      console.log("signup form submitted");
      var model = this.get("model");
      if (model.get("password") !== model.get("repeatedPassword")) {
        this.set("errors.repeatedPassword", "passwords don't match");
      } else {
        $.post("http://localhost:8080/users", JSON.stringify({
          user: {
            username: model.get("username"), 
            email:    model.get("email"),
            password: model.get("password"),
          }
        })).then(function(data) {
          console.log(data);
          var userData = data.user;
          var token    = data.token;
          var user = this.store.createRecord("user", userData);
          var app = this.get("controllers.application");
          app.loginWithUserAndToken(user, token);
          this.send("close");
        }.bind(this), function(r) {
          console.error(r.responseJSON);
          this.set("errors", r.responseJSON);
        }.bind(this));
      }

    },

    close: function() {
      this.set("errors", {});
      return this.send('closeModal');
    }
  }
});
