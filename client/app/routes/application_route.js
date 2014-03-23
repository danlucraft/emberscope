App.ApplicationRoute = Em.Route.extend({

  beforeModel: function() {
    var token = localStorage.token;
    if (token) {
      console.log("token: ", token);
      this.controllerFor("application").loginWithToken(token);
    } else {
      console.log("no token");
      return null;
    }
  },

  actions: {
    openModal: function(name) {
      this.controllerFor(name).set("model", Em.Object.create({}));

      return this.render(name, {
        into: 'application',
        outlet: 'modal'
      });
    },

    closeModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    },
  }
});
