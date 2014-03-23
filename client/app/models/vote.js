
App.Vote = DS.Model.extend({
  user: DS.belongsTo("user"),
  post: DS.belongsTo("post"),
});
