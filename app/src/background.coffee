chrome.app.runtime.onLaunched.addListener =>
  chrome.app.window.create 'views/layout.html',
    id: "main_window"
    innerBounds:
      minWidth: 1000,
      minHeight: 640

chrome.runtime.onMessageExternal.addListener (request, sender, sendResponse) =>
  console.log "onMessageExternal received"
  window.externalSendResponse = sendResponse
  if typeof request.request == "string"
    req = request.request
  else
    req = request.request.command
    data = request.request
    console.log data
  switch req
    when 'ping' 
      window.externalSendResponse { command: "ping", result: true }
    when 'launch'
      chrome.app.window.create 'views/layout.html',
        id: "main_window"
        innerBounds:
          minWidth: 1000,
          minHeight: 640
      window.externalSendResponse { command: "launch", result: true }
    when 'has_session'
      payload = {
        command: 'has_session'
      }
      chrome.app.window.get("main_window").contentWindow.postMessage payload, "*"
    when 'bitid'
      console.log data.uri
      payload = {
        command: 'bitid',
        uri: data.uri
      }
      chrome.app.window.get("main_window").contentWindow.postMessage payload, "*"
  return true

chrome.runtime.onMessage.addListener (request, sender, sendResponse) =>
  console.log "onMessage received"
  console.log request
  if window.externalSendResponse
    window.externalSendResponse request
