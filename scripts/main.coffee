if !navigator.serviceWorker
  return


navigator.serviceWorker.register('./sw.js',{scope:'./'})
.then(()->
  #check if push messaging is supported
  if !PushManager
    return

  ###
We have already checked that the browser supports serviceworker and
push notifications. Now we can subscribe for push notifications from GCM
and obtain the endpoints and the subscription ID.
  ###

  #The browser asks for the permission for sending push notifications
  navigator.serviceWorker.ready.then((serviceWorkerRegistration)->
    #Subscribe to the GCM and obtain the subscription details
    serviceWorkerRegistration.pushManager.subscribe({userVisibleOnly:true})
    .then((subscriptionDetails)->
      #subscriptionDetails is an object with {endpoint, subscriptionID}
      console.log subscriptionDetails
      return
      )
      #incase there is an error
      .catch((e)->
        #check if Permissions API is supported
        if navigator.permissions
          navigator.permissions.query({
            name:'push',
            userVisibleOnly:true
            })
          .then((permissionStatus)->

            #Check if push is supported and what the current state is
            #Checks if the earlier registration is still valid
            navigator.serviceWorker.ready
            .then((serviceWorkerRegistration)->

              #Check if we have subscription already
              serviceWorkerRegistration.pushManager.getSubscription()
              .then((subscription)->
                if !subscription
                  console.log 'no subscription'
                  return

                console.log(subscription)
                return
                )
              )
            )
          return
        ))

  )
