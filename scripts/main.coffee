if navigator.serviceWorker
  return

navigator.serviceWorker.ready
.then((serviceWorkerRegistration)->
  if !serviceWorkerRegistration.pushmanager
    console.log "Push is not supported"

  serviceWorkerRegistration.pushManager.hasPermission()
  .then((pushPermissionStatus)->
    if pushPermissionStatus !='granted'
      console.log 'Permission is not granted'
      )
  )
