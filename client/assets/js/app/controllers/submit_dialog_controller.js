
App.SubmitDialogController = Ember.ObjectController.extend({
  titleError: null,

  actions: {
    submit: function() {
      var model = this.get("model");
      var done = true;

      if (!model.get("title")) {
        this.set("titleError", "Must have a title");
        done = false;
      }

      if (!model.get("url")) {
        this.set("urlError", "Must have a url");
        done = false;
      }

      if (!model.get("username")) {
        this.set("usernameError", "Must have a username");
        done = false;
      }

      if (done) {
        this.store.createRecord("post", {
          title:    model.get("title"),
          url:      model.get("url"),
          username: model.get("username"),
          text:     model.get("text")
        });
        this.send("close");
      }
    },

    close: function() {
      return this.send('closeSubmitModal');
    }
  }
});
