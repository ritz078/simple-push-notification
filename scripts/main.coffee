API_KEY='AIzaSyA5KLt3KqY8kbrZ26I8o50o4mfjgSwAEfM'

showCurlCommand=(subscriptionDetails)->
  command = 'curl --header "Authorization: key='+API_KEY+'" --header Content-Type:"application/json" '+subscriptionDetails.endpoint+' -d "{\\"registration_ids\\":[\\"'+subscriptionDetails.subscriptionId+'\\"]}"'
  document.querySelector('#cmd').innerHTML=command;
  return

clearCurlCommand=()->
  document.querySelector('#cmd').innerHTML=''

if !navigator.serviceWorker
  return

navigator.serviceWorker.ready.then((serviceWorkerRegistration)->
  serviceWorkerRegistration.pushManager.getSubscription().then((subscription)->
    if subscription
      console.log subscription
      document.querySelector('#subscribe').checked=true
      showCurlCommand subscription
      return

    ))


navigator.serviceWorker.register('./sw1.js',{scope:'./'})
.then(()->
  #check if push messaging is supported
  if !PushManager
    return

  ###
  We have already checked that the browser supports serviceworker and
  push notifications. Now we can subscribe for push notifications from GCM
  and obtain the endpoints and the subscription ID.
  ###

  #Listen for checkbox status and subscribe and unsubscribe based on that

  document.querySelector('#subscribe').addEventListener('change',
  (e)->
    if e.target.checked
      subscribe()
      return
    else
      unSubscribe()
      return
      )
  return
  )


subscribe =()->
  #The browser asks for the permission for sending push notifications

    navigator.serviceWorker.ready.then((serviceWorkerRegistration)->
      #Subscribe to the GCM and obtain the subscription details
      serviceWorkerRegistration.pushManager.subscribe({userVisibleOnly:true})
      .then((subscriptionDetails)->
        #subscriptionDetails is an object with {endpoint, subscriptionID}
        console.log subscriptionDetails
        showCurlCommand(subscriptionDetails)
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


unSubscribe=()->
  navigator.serviceWorker.ready
  .then((serviceWorkerRegistration)->
    serviceWorkerRegistration.pushManager.getSubscription()
    .then((pushSubscription)->
      console.log pushSubscription
      if !pushSubscription
        return

      #Now unsubscribe from push
      pushSubscription.unsubscribe().then((successful)->
        console.log successful
        if !successful
          console.log 'unable to unsubscribe from push'
          return

        clearCurlCommand()
        ).catch((e)->
          console.log('Unsubscription error : ',e)
          return
          )))
