App.ApplicationAdapter = DS.RESTAdapter.extend({
  host: "http://localhost:8080",
});

DS.RESTAdapter.reopen({
});

Ember.$.ajaxPrefilter(function(options, originalOptions, jqXHR) {
  var token = localStorage.token;
  if (token) {
    jqXHR.setRequestHeader('X-AUTHENTICATION-TOKEN', token);
  }
});
