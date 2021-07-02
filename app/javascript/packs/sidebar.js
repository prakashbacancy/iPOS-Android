$(document).on('turbolinks:load', function(){
  $('.sidebar-mini').resize()
  $.each($(".sidebar-dropdown > a"), function(ind, element){
    if($(element).parent().hasClass("active")) {
      $(element).next(".sidebar-submenu").slideDown(200);
      // $(element).parent().removeClass("active");
    }
  });

  $(document).on('click', 'li.menu', function(){
    if(!$(this).hasClass('sidebar-dropdown')){
      $(this).addClass('active');
      $('li').removeClass('active');
    }
  })

  $(".sidebar-dropdown > a").click(function() {
    $(".sidebar-submenu").slideUp(200);
    if($(this).parent().hasClass("active")) {
      $(this).parent().removeClass("active");
      $(".sidebar-dropdown").removeClass("active");
    }
    else{
      $(".sidebar-dropdown").removeClass("active");
      $(this).next(".sidebar-submenu").slideDown(200);
      $(this).parent().addClass("active");
    }
  });
  $('.sidebar-submenu > ul > li .active').closest('.sidebar-dropdown').addClass('active')
  $('.sidebar-submenu > ul > li .active').closest('.sidebar-submenu').slideDown(200);
  $('.sidebar-toggle').click(function(){
    if ($('body').hasClass('sidebar-collapse')){
      $('.user-profile').show()
    } else {
      $('.user-profile').hide()
    }
  })
});
