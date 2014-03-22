
App.Post = DS.Model.extend({
  title:        DS.attr("string"),
  username:     DS.attr("string"),
  url:          DS.attr("string"),
  count:        DS.attr("number"),
  commentCount: DS.attr("number"),
  date:         DS.attr("date"),

  domain: function() {
    return "youtube.com";
  }.property("url"),

  dateString: function() {
    return "1000 years ago";
  }.property("date")
});
