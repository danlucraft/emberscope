
App.Post = DS.Model.extend({
  title:              DS.attr("string"),
  user:               DS.belongsTo("user"),
  url:                DS.attr("string"),
  exclusiveVoteCount: DS.attr("number"),
  commentCount:       DS.attr("number"),
  createdAt:          DS.attr("date"),
  hasVoted:           DS.attr("boolean"),

  voteCount: function() {
    return this.get("exclusiveVoteCount") + (this.get("hasVoted") ? 1 : 0);
  }.property("exclusiveVoteCount", "hasVoted"),

  upVote: function(store, user) {
    App.Vote.vote(user, this);
    this.set("hasVoted", true);
  },

  downVote: function(store, user) {
    App.Vote.unvote(user, this);
    this.set("hasVoted", false);
  },

  domain: function() {
    return URI(this.get("url")).domain();
  }.property("url"),

  dateString: function() {
    return this.get("createdAt").toRelativeTime();
  }.property("createdAt"),
});
