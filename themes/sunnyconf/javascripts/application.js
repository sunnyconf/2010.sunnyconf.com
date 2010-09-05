$(document).ready(function(){

  $('#nav').localScroll();
  
  $('.speaker').each(function(){

    $('.inner', this).css({ display: 'none' });

    $('h2', this).each(function(){

      $(this).css({ cursor: 'pointer' });

      $(this).hover(function(){
        $(this).addClass('hover');
      }, function(){
        $(this).removeClass('hover');
      });

      $(this).click(function(){
        $(this).next('.inner').slideToggle('fast');
      });
    });

  });

});
