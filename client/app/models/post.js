
App.Post = DS.Model.extend({
  title:              DS.attr("string"),
  user:               DS.belongsTo("user"),
  url:                DS.attr("string"),
  exclusiveVoteCount: DS.attr("number"),
  commentCount:       DS.attr("number"),
  date:               DS.attr("date"),
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
    return "youtube.com";
  }.property("url"),

  dateString: function() {
    return "1000 years ago";
  }.property("date"),
});
