// Generated by CoffeeScript 1.9.2
(function() {
  var API_KEY, clearCurlCommand, showCurlCommand, subscribe, unSubscribe;

  API_KEY = 'AIzaSyA5KLt3KqY8kbrZ26I8o50o4mfjgSwAEfM';

  showCurlCommand = function(subscriptionDetails) {
    var command;
    command = 'curl --header "Authorization: key=' + API_KEY + '" --header Content-Type:"application/json" ' + subscriptionDetails.endpoint + ' -d "{\\"registration_ids\\":[\\"' + subscriptionDetails.subscriptionId + '\\"]}"';
    document.querySelector('#cmd').innerHTML = command;
  };

  clearCurlCommand = function() {
    return document.querySelector('#cmd').innerHTML = '';
  };

  if (!navigator.serviceWorker) {
    return;
  }

  navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
    return serviceWorkerRegistration.pushManager.getSubscription().then(function(subscription) {
      if (subscription) {
        console.log(subscription);
        document.querySelector('#subscribe').checked = true;
        showCurlCommand(subscription);
      }
    });
  });

  navigator.serviceWorker.register('./sw1.js', {
    scope: './'
  }).then(function() {
    if (!PushManager) {
      return;
    }

    /*
    We have already checked that the browser supports serviceworker and
    push notifications. Now we can subscribe for push notifications from GCM
    and obtain the endpoints and the subscription ID.
     */
    document.querySelector('#subscribe').addEventListener('change', function(e) {
      if (e.target.checked) {
        subscribe();
      } else {
        unSubscribe();
      }
    });
  });

  subscribe = function() {
    return navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
      return serviceWorkerRegistration.pushManager.subscribe({
        userVisibleOnly: true
      }).then(function(subscriptionDetails) {
        console.log(subscriptionDetails);
        showCurlCommand(subscriptionDetails);
      })["catch"](function(e) {
        if (navigator.permissions) {
          navigator.permissions.query({
            name: 'push',
            userVisibleOnly: true
          }).then(function(permissionStatus) {
            return navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
              return serviceWorkerRegistration.pushManager.getSubscription().then(function(subscription) {
                if (!subscription) {
                  console.log('no subscription');
                  return;
                }
                console.log(subscription);
              });
            });
          });
        }
      });
    });
  };

  unSubscribe = function() {
    return navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
      return serviceWorkerRegistration.pushManager.getSubscription().then(function(pushSubscription) {
        console.log(pushSubscription);
        if (!pushSubscription) {
          return;
        }
        return pushSubscription.unsubscribe().then(function(successful) {
          console.log(successful);
          if (!successful) {
            console.log('unable to unsubscribe from push');
            return;
          }
          return clearCurlCommand();
        })["catch"](function(e) {
          console.log('Unsubscription error : ', e);
        });
      });
    });
  };

}).call(this);


//# sourceMappingURL=main.js.map
