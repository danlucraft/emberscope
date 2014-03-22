App.ApplicationRoute = Em.Route.extend({
  actions: {
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
