jQuery(document).ready(function() {
  jQuery('.editable').each(function() {
    var editable = new Editable(this);
  });
  
  jQuery('#new_book').each(function() {
      var autofill = new AutoFill(this);
  });
  
  jQuery('.histogram').each(function() {
    new HistogramFromTable(this);
  });
  
  setTimeout(function() {
    jQuery('.notice').each(function() {
      jQuery(this).animate({
        marginBottom: 0,
        height: 0,
        opacity: 0
      }, 250, 'linear', function() {
        jQuery(this).remove();
      });
    });
  }, 3*1000);
});
