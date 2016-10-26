$(document).ready(function() {
  $('.owl-carousel').owlCarousel();
});

$(document).on('page:change', function() {
  $(window).scroll(function() {
    if ($(this).scrollTop() > 50) {
      $('#back-to-top').fadeIn();
    } else {
      $('#back-to-top').fadeOut();
    }
  });
  $('#back-to-top').click(function() {
    $('#back-to-top').tooltip('hide');
    $('body,html').animate({
      scrollTop: 0
    }, 800);
    return false;
  });
  $('#back-to-top').tooltip('show');
});

$(function() {
  jQuery(window).scroll(function() {
    if (jQuery(window).scrollTop() > 400) {
      jQuery('#navigation').css('background-color', '#204060');
      jQuery('#navigation').addClass('animated-nav');
    } else {
      jQuery('#navigation').css('background-color', 'transparent');
      jQuery('#navigation').removeClass('animated-nav');
    }
  });

  var slideHeight = $(window).height();
  $('#home-carousel .carousel-inner .item, #home-carousel .video-container').css('height', slideHeight);

  $(window).resize(function() {
    'use strict',
    $('#home-carousel .carousel-inner .item, #home-carousel .video-container').css('height', slideHeight);
  });
});

wow = new WOW({
  animateClass: 'animated',
  offset: 100,
  mobile: false
});
wow.init();

$(document).on('page:change', function(){
  $(".menu_notifications").hover(
    function() {
      $('.dropdown-menu', this).not('.in .dropdown-menu').stop(true,true).slideDown("400");
      $(this).toggleClass('open');
    },
    function() {
      $('.dropdown-menu', this).not('.in .dropdown-menu').stop(true,true).slideUp("400");
      $(this).toggleClass('open');
    }
  );
});
