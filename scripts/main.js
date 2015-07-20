if (navigator.serviceWorker) {
  return;
}

navigator.serviceWorker.ready.then(function(serviceWorkerRegistration) {
  if (!serviceWorkerRegistration.pushmanager) {
    console.log("Push is not supported");
  }
  return serviceWorkerRegistration.pushManager.hasPermission().then(function(pushPermissionStatus) {
    if (pushPermissionStatus !== 'granted') {
      return console.log('Permission is not granted');
    }
  });
});
