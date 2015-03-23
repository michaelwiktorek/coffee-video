canvas = null
ctx = null
video = null
animation_id = null
playing = false
gradient = false
chroma = false
threshold = 0
r = 0
g = 0
b = 0

ImageEditor = require "./image_editor.coffee"
editor = new ImageEditor(42)

window.onload = ->
  canvas = document.querySelector('canvas')
  ctx = canvas.getContext('2d')
  document.querySelector('#start_button').onclick = start
  document.querySelector('#stop_button').onclick = stop

  document.querySelector('#start_canvas_button').onclick = start_gradient
  document.querySelector('#stop_canvas_button').onclick = stop_gradient
  document.querySelector('#sobel_snapshot').onclick = gradient_snapshot
  document.querySelector('#grad_slider').oninput = set_threshold

  document.querySelector('#start_direct').onclick = start_canvas
  document.querySelector('#stop_direct').onclick = stop_canvas

  document.querySelector('#start_chroma').onclick = start_chroma
  document.querySelector('#stop_chroma').onclick = stop_chroma
  document.querySelector('#rslider').oninput = set_r
  document.querySelector('#gslider').oninput = set_g
  document.querySelector('#bslider').oninput = set_b


start = ->
  navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia
  video = document.querySelector('video')
  navigator.getUserMedia({video: true, audio: false}, 
    (stream)->
      video.src = window.URL.createObjectURL(stream)
    , ->
      alert "error")

stop = ->
  video.src = ''

update = ->
  ctx.drawImage(video, 0, 0)
  if gradient
    sobel_filter()
  else if chroma
    chroma_key()
  animation_id = window.requestAnimationFrame(update)

start_gradient = ->
  if not chroma
    gradient = true

stop_gradient = ->
  if not chroma
    gradient = false

sobel_filter = ->
  editor.sobel_filter(ctx, threshold)

gradient_snapshot = ->
  ctx.drawImage(video, 0, 0)
  sobel_filter()
  playing = false
  gradient = false
  chroma = false
  window.cancelAnimationFrame(animation_id)

set_threshold = ->
  slider = document.querySelector('#grad_slider')
  threshold = slider.value

start_chroma = ->
  if not gradient
    chroma = true

stop_chroma = ->
  if not gradient
    chroma = false

chroma_key = ->
  editor.chroma_key(ctx, r, g, b)

start_canvas = ->
  playing = true
  animation_id = window.requestAnimationFrame(update)

stop_canvas = ->
  playing = false
  gradient = false
  chroma = false
  ctx.clearRect(0,0,canvas.width,canvas.height)
  window.cancelAnimationFrame(animation_id)

set_r = ->
  slider = document.querySelector('#rslider')
  r = slider.value
set_g = ->
  slider = document.querySelector('#gslider')
  g = slider.value
set_b = ->
  slider = document.querySelector('#bslider')
  b = slider.value