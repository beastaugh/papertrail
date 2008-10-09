jQuery(document).ready(function() {
  jQuery('.book').each(function() {
    var editable = new Editable(this);
  });
});
