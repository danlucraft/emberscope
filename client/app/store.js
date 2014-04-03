// App.ApplicationAdapter = DS.FixtureAdapter;

// in this demo we are using the LocalStorageAdapter to persist data
App.ApplicationAdapter = DS.RESTAdapter.extend({
  host: "http://localhost:8080",
});

DS.RESTAdapter.reopen({
  headers: function() {
    console.log("headers!");
    return {}
  },
});

