// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

$(document).ready(function() {

  var textField = $("#post_content"),
      btnPost   = $("#btn-post"),
      postPix   = $("#post_picture");

  // client-side disable of post btn if
  // 1. text field is empty WITHOUT picture upload
  // 2. text field is blank (e.g. "  ") WITHOUT picture upload

  textField.keyup(function() {
    if(!$.trim($(this).val()) && !postPix.val()) {  // if not empty/blank && file not blank
       btnPost.attr("disabled", true); // or .prop
    } else if ($.trim($(this).val())) {
       btnPost.attr("disabled", false);
    }
  });

  // enable post btn if a picture upload exists
  postPix.change(function() {
    if ($(this).val()) {
      btnPost.attr("disabled", false);
    } else if ($(this).val() === "") {
      btnPost.attr("disabled", true);
    }
  });
 });