jQuery(document).ready(function() {
  jQuery('.editable').each(function() {
    var editable = new Editable(this);
  });
  
  setTimeout(function() {
    jQuery('.notice').each(function() {
      jQuery(this).animate({marginBottom: 0, height: 0, opacity: 0}, 500, 'linear', function() {
        jQuery(this).remove();
      });
    });
  }, 5*1000);
});
