App.ApplicationRoute = Em.Route.extend({

  beforeModel: function() {
    var token = localStorage.token;
    if (token) {
      console.log("token: ", token);
    } else {
      console.log("no token");
      return null;
    }
  },

  actions: {
    openLoginModal: function() {
      this.controllerFor("login-dialog").set("model", Em.Object.create({}));

      return this.render("login-dialog", {
        into: 'application',
        outlet: 'modal'
      });
    },

    closeLoginModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    },

    openSubmitModal: function() {
      this.controllerFor("submit-dialog").set("model", Em.Object.create({}));

      return this.render("submit-dialog", {
        into: 'application',
        outlet: 'modal'
      });
    },

    closeSubmitModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    }
  }
});
