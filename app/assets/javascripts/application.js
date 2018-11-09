// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery
//= require bootstrap-sprockets
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require chosen-jquery
//= require lib/mousetrap/mousetrap.js
//= require lib/mousetrap/mousetrap-bind-dictionary.min.js
//= require lib/sweetalert2.min.js
//= require lib/pace.min.js
//= require lib/chart.min.js
//= require lib/flash.js
//= require lib/i18n.js

$(document).ready(function(){
  // Initialize flash msgs
  Flash.search();

  // Initialize mousetrap binding
  Mousetrap.bind({
    '?': function modal() { $('#help').modal('toggle'); },
    // Go To
    'g u': function() { window.location.href = $('#sUsers').attr('href'); },
    'g d': function() { window.location.href = $('#sDashboard').attr('href'); },
    'g a': function() { window.location.href = $('#sAccounts').attr('href'); },
    'g c': function() { window.location.href = $('#sContacts').attr('href'); },
    'g l': function() { window.location.href = $('#sLeads').attr('href'); },
    'g m': function() { window.location.href = $('#sDeals').attr('href'); },
    // Actions
    'c a': function() { window.location.href = $('#sAccounts').attr('href') + '/new'; },
    'c c': function() { window.location.href = $('#sContacts').attr('href') + '/new'; },
    'c l': function() { window.location.href = $('#sLeads').attr('href') + '/new'; },
    'c m': function() { window.location.href = $('#sDeals').attr('href') + '/new'; },
  });
});
