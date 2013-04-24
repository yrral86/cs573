# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@play_sequence =
  (a,b,c,d,e,f,g,h,i,j) ->
    alert([a,b,c,d,e,f,g,h,i,j].join())
    show_proceed()
    false

@show_proceed =
  () -> $(".proceed").show()