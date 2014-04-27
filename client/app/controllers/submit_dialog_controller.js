
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

      if (done) {
        var post = this.store.createRecord("post", {
          title:    model.get("title"),
          url:      model.get("url"),
          text:     model.get("text")
        });
        post.save();
        this.send("close");
      }
    },

    close: function() {
      return this.send('closeModal');
    }
  }
});
