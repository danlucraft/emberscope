App.ApplicationAdapter = DS.RESTAdapter.extend({
  host: "http://localhost:8080",
});

DS.RESTAdapter.reopen({
});


//App.PostSerializer = DS.RESTSerializer.extend({
  //extractMeta: function() {
  //},
//
  //extractArray: function(store, type, payload, id, requestType) {
    ////console.log("sfdo");
    ////console.log(payload);
    ////var meta = payload.meta;
    ////console.log(meta)
    ////delete payload.meta;
    //var array = this._super(store, type, payload, id, requestType);
    ////console.log(array);
    ////array.meta = meta;
    //return array
  //}
//});

Ember.$.ajaxPrefilter(function(options, originalOptions, jqXHR) {
  var token = localStorage.token;
  if (token) {
    jqXHR.setRequestHeader('X-AUTHENTICATION-TOKEN', token);
  }
});
