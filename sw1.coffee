self.addEventListener('push',(e)->
  console.log "push message received"
  console.log "hello"

  title='a'
  body='b'
  icon='c'
  data='d'



  showNotification=(title, body, icon, data)->
    notificationOptions = {
      body: body,
      icon:'images/touch/chrome-touch-icon-192x192.png',
      tag: 'simple-push-demo-notification',
      data: data
    };

    if self.registration.showNotification
      self.registration.showNotification(title, notificationOptions);
      return 0;
    else
      new Notification(title, notificationOptions);

  showNotification(title,body,icon,data)
  return

  )
